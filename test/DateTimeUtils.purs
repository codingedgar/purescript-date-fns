module Test.DateTimeUtils where

import Prelude
import Data.Date as Date
import Data.DateTime as DateTime
import Data.Enum (toEnum)
import Data.Maybe (fromJust)
import Partial.Unsafe (unsafePartial)

mkUnsafeDate :: Int -> Date.Month -> Int -> Date.Date
mkUnsafeDate year month day = (unsafePartial $ fromJust $ Date.canonicalDate <$> toEnum year <@> month <*> toEnum day)

mkUnsafeTime :: Int -> Int -> Int -> Int -> DateTime.Time
mkUnsafeTime hours minutes seconds milliseconds = (unsafePartial $ fromJust $ DateTime.Time <$> toEnum hours <*> toEnum minutes <*> toEnum seconds <*> toEnum milliseconds)

mkUnsafeDateTime :: Int -> Date.Month -> Int -> Int -> Int -> Int -> Int -> DateTime.DateTime
mkUnsafeDateTime year month day hours minutes seconds milliseconds = DateTime.DateTime (mkUnsafeDate year month day) (mkUnsafeTime hours minutes seconds milliseconds)
