module DateFns where

import Prelude

import Data.DateTime as DateTime
import Data.DateTime.Instant as DateTime.Instant
import Data.Function.Uncurried (Fn1, Fn2, Fn3, runFn1, runFn2, runFn3)
import Data.Time.Duration (Milliseconds)
import Foreign (Foreign)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)

-- import Unsafe.Coerce (unsafeCoerce)

foreign import data Date :: Type

foreign import toDateImpl :: Milliseconds -> Date
foreign import showDateImpl :: Date -> String

instance showDate :: Show Date where
  show :: Date -> String
  show = showDateImpl

fromDateTime :: DateTime.DateTime -> Date
fromDateTime =
  DateTime.Instant.fromDateTime
    >>> DateTime.Instant.unInstant
    >>> toDateImpl

type IntlFormatDistanceOptions =
  ( unit :: String
  , locale :: String
  , localeMatcher :: String
  , numeric :: String
  , style :: String
  )

foreign import intlFormatDistanceImp :: forall opts. Fn3 Date Date opts String

intlFormatDistance :: forall opts opts_. Union opts opts_ IntlFormatDistanceOptions => Date -> Date -> Record opts -> String
intlFormatDistance date baseDate opts =
  runFn3 intlFormatDistanceImp date baseDate opts

intlFormatDistance' :: forall opts opts_. Union opts opts_ IntlFormatDistanceOptions => DateTime.DateTime -> DateTime.DateTime -> Record opts -> String
intlFormatDistance' date baseDate opts =
  intlFormatDistance (fromDateTime date) (fromDateTime baseDate) opts

type Duration =
  ( years :: Int
  , months :: Int
  , weeks :: Int
  , days :: Int
  , hours :: Int
  , minutes :: Int
  , seconds :: Int
  )

type FormatDurationImpOptions =
  ( format :: (Array String)
  , zero :: Boolean
  , delimiter :: String
  , locale :: String
  )

foreign import formatDurationImp :: forall durs opts. Fn2 durs opts String

formatDuration :: forall durs durs_ opts opts_. Union durs durs_ Duration => Union opts opts_ FormatDurationImpOptions => Record durs -> Record opts -> String
formatDuration duration opts =
  runFn2 formatDurationImp duration opts

type Interval =
  { start :: Date
  , end :: Date
  }

foreign import intervalToDurationImp :: Fn1 Interval Foreign

intervalToDuration :: forall durs durs_. Union durs durs_ Duration => Interval -> Record durs
intervalToDuration interval =
  runFn1 intervalToDurationImp interval # unsafeCoerce

intervalToDuration'
  :: forall durs durs_
   . Union durs durs_ Duration
  => { start :: DateTime.DateTime
     , end :: DateTime.DateTime
     }
  -> Record durs
intervalToDuration' interval =
  intervalToDuration { start: fromDateTime interval.start, end: fromDateTime interval.end }
