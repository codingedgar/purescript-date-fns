module Test.Spec.FromDateTime where

import Prelude

import Data.Date as Date
import DateFns (fromDateTime)
import Test.DateTimeUtils (mkUnsafeDateTime)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "fromDateTime" do
    it "show correctly" do
      shouldEqual
        (show (fromDateTime (mkUnsafeDateTime 2022 Date.November 1 0 0 0 0)))
        "2022-11-01T00:00:00.000Z"
