module DateFns
  ( format
  , formatDuration
  , intervalToDuration
  , intlFormatDistance
  , parse
  , parseJSON
  ) where

import Prelude

import Data.Function.Uncurried (Fn1, Fn2, Fn3, Fn4, runFn1, runFn2, runFn3, runFn4)
import DateFns.Types (Date, Duration, FormatDurationImpOptions, FormatOptions, Interval, IntlFormatDistanceOptions, ParseOptions)
import Foreign (Foreign)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)

foreign import _intlFormatDistance :: forall opts. Fn3 Date Date opts String

intlFormatDistance :: forall opts opts_. Union opts opts_ IntlFormatDistanceOptions => Record opts -> Date -> Date -> String
intlFormatDistance opts date baseDate =
  runFn3 _intlFormatDistance date baseDate opts

foreign import _formatDuration :: forall durs opts. Fn2 durs opts String

formatDuration :: forall durs durs_ opts opts_. Union durs durs_ Duration => Union opts opts_ FormatDurationImpOptions => Record opts -> Record durs -> String
formatDuration opts duration =
  runFn2 _formatDuration duration opts

foreign import _intervalToDuration :: Fn1 Interval Foreign

intervalToDuration :: forall durs durs_. Union durs durs_ Duration => Interval -> Record durs
intervalToDuration interval =
  runFn1 _intervalToDuration interval # unsafeCoerce

foreign import _parse :: forall ops. Fn4 String String Date ops Date

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

foreign import _parseJSON :: Fn1 String Date

-- | https://date-fns.org/v2.29.3/docs/parseJSON
parseJSON :: String -> Date
parseJSON = runFn1 _parseJSON

foreign import _format :: forall ops. Fn3 Date String ops String

format
  :: forall opts opts_
   . Union opts opts_ FormatOptions
  => Record opts
  -> String
  -> Date
  -> String
format options fmt date =
  runFn3 _format date fmt options
