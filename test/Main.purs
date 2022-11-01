module Test.Main where

import Prelude

import Data.Date as Date
import DateFns (formatDuration, fromDateTime, intervalToDuration, intervalToDuration', intlFormatDistance, intlFormatDistance')
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.DateTimeUtils (mkUnsafeDateTime)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

-- main :: Effect Unit
-- main = launchAff_ do
--   discover "Test\\.Spec\\."
--     >>= runSpec [ consoleReporter ]
main :: Effect Unit
main = launchAff_ $ runSpec [ consoleReporter ] do
  describe "fromDateTime" do
    it "show correctly" do
      shouldEqual
        (show (fromDateTime (mkUnsafeDateTime 2022 Date.November 1 0 0 0 0)))
        "2022-11-01T00:00:00.000Z"
  describe "intlFormatDistance" do
    it "show correctly" do
      shouldEqual
        (intlFormatDistance {} (fromDateTime $ mkUnsafeDateTime 2022 Date.October 31 12 0 0 0) (fromDateTime $ mkUnsafeDateTime 2022 Date.November 1 0 0 0 0))
        "12 hours ago"
  describe "intlFormatDistance'" do
    it "show correctly" do
      shouldEqual
        (intlFormatDistance' {} (mkUnsafeDateTime 2022 Date.October 31 12 0 0 0) (mkUnsafeDateTime 2022 Date.November 1 0 0 0 0))
        "12 hours ago"
  describe "formatDuration" do
    it "Format full duration" do
      shouldEqual
        ( formatDuration
            {}
            { years: 2
            , months: 9
            , weeks: 1
            , days: 7
            , hours: 5
            , minutes: 9
            , seconds: 30
            }
        )
        "2 years 9 months 1 week 7 days 5 hours 9 minutes 30 seconds"
    it "Customize the format" do
      shouldEqual
        ( formatDuration
            { format: [ "months", "weeks" ] }
            { years: 2
            , months: 9
            , weeks: 1
            , days: 7
            , hours: 5
            , minutes: 9
            , seconds: 30
            }

        )
        "9 months 1 week"
    it "Customize the delimiter" do
      shouldEqual
        ( formatDuration
            { delimiter: ", " }
            { years: 2, months: 9, weeks: 3 }
        )
        "2 years, 9 months, 3 weeks"
  describe "intervalToDuration" do
    it "Get the duration between January 15, 1929 and April 4, 1968." do
      shouldEqual
        ( intervalToDuration
            { start: (fromDateTime $ mkUnsafeDateTime 1929 Date.January 15 12 0 0 0)
            , end: (fromDateTime $ mkUnsafeDateTime 1968 Date.April 4 19 5 0 0)
            }
        )
        { years: 39, months: 2, days: 20, hours: 7, minutes: 5, seconds: 0 }
  describe "intervalToDuration'" do
    it "Get the duration between January 15, 1929 and April 4, 1968." do
      shouldEqual
        ( intervalToDuration'
            { start: mkUnsafeDateTime 1929 Date.January 15 12 0 0 0
            , end: mkUnsafeDateTime 1968 Date.April 4 19 5 0 0
            }
        )
        { years: 39, months: 2, days: 20, hours: 7, minutes: 5, seconds: 0 }

