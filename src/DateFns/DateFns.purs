module DateFns
  ( Date
  , Duration
  , FormatDurationImpOptions
  , Interval
  , IntlFormatDistanceOptions
  , formatDuration
  , fromDateTime
  , intervalToDuration
  , intervalToDuration'
  , intlFormatDistance
  , intlFormatDistance'
  , parse
  , parse'
  ) where

import Prelude

import Data.DateTime as DateTime
import Data.DateTime.Instant as DateTime.Instant
import Data.Function.Uncurried (Fn1, Fn2, Fn3, Fn4, runFn1, runFn2, runFn3, runFn4)
import Data.Time.Duration (Milliseconds)
import DateFns.Types (Locale)
import Foreign (Foreign)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)

foreign import data Date :: Type

foreign import _toDate :: Milliseconds -> Date
foreign import _showDate :: Date -> String

instance showDate :: Show Date where
  show :: Date -> String
  show = _showDate

fromDateTime :: DateTime.DateTime -> Date
fromDateTime =
  DateTime.Instant.fromDateTime
    >>> DateTime.Instant.unInstant
    >>> _toDate

type IntlFormatDistanceOptions =
  ( unit :: String
  , locale :: String
  , localeMatcher :: String
  , numeric :: String
  , style :: String
  )

foreign import _intlFormatDistance :: forall opts. Fn3 Date Date opts String

intlFormatDistance :: forall opts opts_. Union opts opts_ IntlFormatDistanceOptions => Record opts -> Date -> Date -> String
intlFormatDistance opts date baseDate =
  runFn3 _intlFormatDistance date baseDate opts

intlFormatDistance' :: forall opts opts_. Union opts opts_ IntlFormatDistanceOptions => Record opts -> DateTime.DateTime -> DateTime.DateTime -> String
intlFormatDistance' opts date baseDate =
  intlFormatDistance opts (fromDateTime date) (fromDateTime baseDate)

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

foreign import _formatDuration :: forall durs opts. Fn2 durs opts String

formatDuration :: forall durs durs_ opts opts_. Union durs durs_ Duration => Union opts opts_ FormatDurationImpOptions => Record opts -> Record durs -> String
formatDuration opts duration =
  runFn2 _formatDuration duration opts

type Interval =
  { start :: Date
  , end :: Date
  }

foreign import _intervalToDuration :: Fn1 Interval Foreign

intervalToDuration :: forall durs durs_. Union durs durs_ Duration => Interval -> Record durs
intervalToDuration interval =
  runFn1 _intervalToDuration interval # unsafeCoerce

intervalToDuration'
  :: forall durs durs_
   . Union durs durs_ Duration
  => { start :: DateTime.DateTime
     , end :: DateTime.DateTime
     }
  -> Record durs
intervalToDuration' interval =
  intervalToDuration { start: fromDateTime interval.start, end: fromDateTime interval.end }

foreign import _parse :: forall ops. Fn4 String String Date ops Date

type ParseOptions =
  ( locale :: Locale
  , weekStartOn :: Int
  , firstWeekContainsDate :: Int
  , useAdditionalWeekYearTokens :: Boolean
  , useAdditionalDayOfYearTokens :: Boolean
  )

parse
  :: forall durs durs_
   . Union durs durs_ ParseOptions
  => Record durs
  -> Date
  -> String
  -> String
  -> Date
parse options referenceDate formatString dateString =
  runFn4 _parse dateString formatString referenceDate options

parse'
  :: forall durs durs_
   . Union durs durs_ ParseOptions
  => Record durs
  -> DateTime.DateTime
  -> String
  -> String
  -> Date
parse' options referenceDate formatString dateString =
  runFn4 _parse dateString formatString (fromDateTime referenceDate) options
