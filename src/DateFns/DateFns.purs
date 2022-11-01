module DateFns where

import Prelude

import Data.DateTime as DateTime
import Data.DateTime.Instant as DateTime.Instant
import Data.Options (Option, Options, opt, options)
import Data.Time.Duration (Milliseconds)
import Effect (Effect)
import Effect.Uncurried (EffectFn3, runEffectFn3)
import Foreign (Foreign)

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

data IntlFormatDistanceOptions

unit :: Option IntlFormatDistanceOptions String
unit = opt "unit"

locale :: Option IntlFormatDistanceOptions String
locale = opt "locale"

localeMatcher :: Option IntlFormatDistanceOptions String
localeMatcher = opt "localeMatcher"

numeric :: Option IntlFormatDistanceOptions String
numeric = opt "numeric"

style :: Option IntlFormatDistanceOptions String
style = opt "style"

foreign import intlFormatDistanceImp :: EffectFn3 Date Date Foreign String

intlFormatDistance :: Date -> Date -> Options IntlFormatDistanceOptions -> Effect String
intlFormatDistance date baseDate opts =
  runEffectFn3 intlFormatDistanceImp date baseDate (options opts)

intlFormatDistance' :: DateTime.DateTime -> DateTime.DateTime -> Options IntlFormatDistanceOptions -> Effect String
intlFormatDistance' date baseDate opts =
  runEffectFn3 intlFormatDistanceImp (fromDateTime date) (fromDateTime baseDate) (options opts)
