module Test.Main where

import Prelude

import Data.Date as Date
import Data.DateTime.DateFns as DateTime.DateFns
import DateFns as DateFns
import DateFns.Locale.Locale (eo)
import DateFns.Types (fromDateTime)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Now (nowDateTime)
import Test.DateTimeUtils (mkUnsafeDateTime)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = launchAff_ $ runSpec [ consoleReporter ] do
  describe "Utils" do
    describe "fromDateTime" do
      it "show correctly" do
        shouldEqual
          (show (fromDateTime (mkUnsafeDateTime 2022 Date.November 1 0 0 0 0)))
          "2022-11-01T00:00:00.000Z"
  describe "DateFns" do
    describe "intlFormatDistance" do
      it "show correctly 1" do
        shouldEqual
          ( DateFns.intlFormatDistance
              { numeric: "always"
              , unit: "hour"
              }
              (fromDateTime $ mkUnsafeDateTime 2022 Date.October 31 12 0 0 0)
              (fromDateTime $ mkUnsafeDateTime 2022 Date.November 1 0 0 0 0)
          )
          "12 hours ago"
    describe "formatDuration" do
      it "Format full duration" do
        shouldEqual
          ( DateFns.formatDuration
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
          ( DateFns.formatDuration
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
          ( DateFns.formatDuration
              { delimiter: ", " }
              { years: 2, months: 9, weeks: 3 }
          )
          "2 years, 9 months, 3 weeks"
    describe "intervalToDuration" do
      it "Get the duration between January 15, 1929 and April 4, 1968." do
        shouldEqual
          ( DateFns.intervalToDuration
              { start: (fromDateTime $ mkUnsafeDateTime 1929 Date.January 15 12 0 0 0)
              , end: (fromDateTime $ mkUnsafeDateTime 1968 Date.April 4 19 5 0 0)
              }
          )
          { years: 39, months: 2, days: 20, hours: 7, minutes: 5, seconds: 0 }
    describe "parse" do
      it "Parse 11 February 2014 from middle-endian format" do
        now <- liftEffect nowDateTime
        ( DateFns.parse
            {}
            (fromDateTime now)
            "MM/dd/yyyy"
            "02/11/2014"
        )
          # show
          # shouldEqual "2014-02-11T00:00:00.000Z"
      it "Parse 28th of February in Esperanto locale in the context of 2010 year" do
        ( DateFns.parse
            { locale: eo
            }
            (fromDateTime (mkUnsafeDateTime 2010 Date.January 1 0 0 0 0))
            "do 'de' MMMM"
            "28-a de februaro"
        )
          # show
          # shouldEqual "2010-02-28T00:00:00.000Z"
    describe "parseJSON" do
      it "Parse 28th of February in Esperanto locale in the context of 2010 year" do
        ( DateFns.parseJSON "2000-03-15T05:20:10.123Z"
        )
          # show
          # shouldEqual "2000-03-15T05:20:10.123Z"
    describe "format" do
      it "Represent 11 February 2014 in middle-endian format:" do
        ( DateFns.format
            {}
            "MM/dd/yyyy"
            (fromDateTime (mkUnsafeDateTime 2014 Date.February 11 0 0 0 0))
        )
          # shouldEqual "02/11/2014"

  describe "Data.DateTime.DateFns" do
    describe "intlFormatDistance" do
      it "show correctly" do
        shouldEqual
          ( DateTime.DateFns.intlFormatDistance
              { numeric: "always"
              , unit: "hour"
              }
              (mkUnsafeDateTime 2022 Date.October 31 12 0 0 0)
              (mkUnsafeDateTime 2022 Date.November 1 0 0 0 0)
          )
          "12 hours ago"
    describe "intervalToDuration" do
      it "Get the duration between January 15, 1929 and April 4, 1968." do
        shouldEqual
          ( DateTime.DateFns.intervalToDuration
              { start: mkUnsafeDateTime 1929 Date.January 15 12 0 0 0
              , end: mkUnsafeDateTime 1968 Date.April 4 19 5 0 0
              }
          )
          { years: 39, months: 2, days: 20, hours: 7, minutes: 5, seconds: 0 }
    describe "parse" do
      it "Parse 28th of February in Esperanto locale in the context of 2010 year" do
        ( DateTime.DateFns.parse
            { locale: eo
            }
            (mkUnsafeDateTime 2010 Date.January 1 0 0 0 0)
            "do 'de' MMMM"
            "28-a de februaro"
        )
          # shouldEqual (mkUnsafeDateTime 2010 Date.February 28 0 0 0 0)
    -- it "Parse Input dateTimeLocal" do
    --   ( DateTime.DateFns.parse
    --       {}
    --       -- (mkUnsafeDateTime 2022 Date.November 10 0 0 0 0)
    --       (mkUnsafeDateTime 2010 Date.January 1 0 0 0 0)
    --       "yyyy-MM-dd'T'HH:mm"
    --       "2022-11-08T22:27"
    --   )
    --     # shouldEqual (mkUnsafeDateTime 2010 Date.February 28 0 0 0 0)
    describe "parseJSON" do
      it "Parse 28th of February in Esperanto locale in the context of 2010 year" do
        ( DateTime.DateFns.parseJSON "2000-03-15T05:20:10.123Z"
        )
          # shouldEqual (mkUnsafeDateTime 2000 Date.March 15 5 20 10 123)
    describe "format" do
      it "Represent 11 February 2014 in middle-endian format:" do
        ( DateTime.DateFns.format
            {}
            "MM/dd/yyyy"
            (mkUnsafeDateTime 2014 Date.February 11 0 0 0 0)
        )
          # shouldEqual "02/11/2014"
    describe "format" do
      it "Represent 11 February 2014 in middle-endian format:" do
        ( DateTime.DateFns.format
            {}
            "MM/dd/yyyy"
            (mkUnsafeDateTime 2014 Date.February 11 0 0 0 0)
        )
          # shouldEqual "02/11/2014"

