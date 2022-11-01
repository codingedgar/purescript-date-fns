module Test.Spec.FormatDuration where

import Prelude

import DateFns (formatDuration)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "formatDuration" do
    it "Format full duration" do
      shouldEqual
        ( formatDuration
            { years: 2
            , months: 9
            , weeks: 1
            , days: 7
            , hours: 5
            , minutes: 9
            , seconds: 30
            }
            {}
        )
        "2 years 9 months 1 week 7 days 5 hours 9 minutes 30 seconds"
    it "Customize the format" do
      shouldEqual
        ( formatDuration
            { years: 2
            , months: 9
            , weeks: 1
            , days: 7
            , hours: 5
            , minutes: 9
            , seconds: 30
            }
            { format: [ "months", "weeks" ] }
        )
        "9 months 1 week"
    it "Customize the delimiter" do
      shouldEqual
        ( formatDuration
            { years: 2, months: 9, weeks: 3 }
            { delimiter: ", " }
        )
        "2 years, 9 months, 3 weeks"
