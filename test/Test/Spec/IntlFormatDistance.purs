module Test.Spec.IntlFormatDistance where

import Prelude

import Data.Date as Date
import DateFns (fromDateTime, intlFormatDistance, intlFormatDistance')
import Test.DateTimeUtils (mkUnsafeDateTime)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "intlFormatDistance" do
    it "show correctly" do
      shouldEqual
        (intlFormatDistance (fromDateTime $ mkUnsafeDateTime 2022 Date.October 31 12 0 0 0) (fromDateTime $ mkUnsafeDateTime 2022 Date.November 1 0 0 0 0) {})
        "12 hours ago"
  describe "intlFormatDistance'" do
    it "show correctly" do
      shouldEqual
        (intlFormatDistance' (mkUnsafeDateTime 2022 Date.October 31 12 0 0 0) (mkUnsafeDateTime 2022 Date.November 1 0 0 0 0) {})
        "12 hours ago"
