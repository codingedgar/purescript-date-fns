module DateFns.Types where

import Prelude
import Data.DateTime as DateTime
import Data.DateTime.Instant as DateTime.Instant
import Data.Time.Duration (Milliseconds)

foreign import data Locale :: Type
foreign import data Date :: Type
foreign import _toDate :: Milliseconds -> Date
foreign import _showDate :: Date -> String
foreign import _toInstant :: Date -> DateTime.Instant.Instant

instance showDate :: Show Date where
  show :: Date -> String
  show = _showDate

fromDateTime :: DateTime.DateTime -> Date
fromDateTime =
  DateTime.Instant.fromDateTime
    >>> DateTime.Instant.unInstant
    >>> _toDate

toDateTime :: Date -> DateTime.DateTime
toDateTime = _toInstant >>> DateTime.Instant.toDateTime

type IntlFormatDistanceOptions =
  ( unit :: String
  , locale :: String
  , localeMatcher :: String
  , numeric :: String
  , style :: String
  )

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

type Interval =
  { start :: Date
  , end :: Date
  }

type ParseOptions =
  ( locale :: Locale
  , weekStartOn :: Int
  , firstWeekContainsDate :: Int
  , useAdditionalWeekYearTokens :: Boolean
  , useAdditionalDayOfYearTokens :: Boolean
  )

type FormatOptions =
  ( locale :: Locale
  , weekStartOn :: Int
  , firstWeekContainsDate :: Int
  , useAdditionalWeekYearTokens :: Boolean
  , useAdditionalDayOfYearTokens :: Boolean
  )

-- type FormatDistanceToNowOptions =
--   ( includeSeconds :: Boolean
--   , addSuffix :: Boolean
--   , locale :: Locale
--   )
