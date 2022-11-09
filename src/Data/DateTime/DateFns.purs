module Data.DateTime.DateFns where

import Prelude

import Data.DateTime as DateTime
import DateFns as DateFns
import DateFns.Types (Duration, IntlFormatDistanceOptions, ParseOptions, FormatOptions, fromDateTime, toDateTime)
import Prim.Row (class Union)

intlFormatDistance :: forall opts opts_. Union opts opts_ IntlFormatDistanceOptions => Record opts -> DateTime.DateTime -> DateTime.DateTime -> String
intlFormatDistance opts date baseDate =
  DateFns.intlFormatDistance opts (fromDateTime date) (fromDateTime baseDate)

intervalToDuration
  :: forall durs durs_
   . Union durs durs_ Duration
  => { start :: DateTime.DateTime
     , end :: DateTime.DateTime
     }
  -> Record durs
intervalToDuration interval =
  DateFns.intervalToDuration { start: fromDateTime interval.start, end: fromDateTime interval.end }

parse
  :: forall durs durs_
   . Union durs durs_ ParseOptions
  => Record durs
  -> DateTime.DateTime
  -> String
  -> String
  -> DateTime.DateTime
parse options referenceDate formatString dateString =
  toDateTime $ DateFns.parse options (fromDateTime referenceDate) formatString dateString

-- TODO: needs a safe version for Invalid Date
-- | https://date-fns.org/v2.29.3/docs/parseJSON
parseJSON :: String -> DateTime.DateTime
parseJSON = DateFns.parseJSON >>> toDateTime

format
  :: forall opts opts_
   . Union opts opts_ FormatOptions
  => Record opts
  -> String
  -> DateTime.DateTime
  -> String
format options fmt date =
  DateFns.format options fmt (fromDateTime date)
