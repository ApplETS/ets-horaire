# -*- encoding : utf-8 -*-
require 'spec_helper'

PeriodStruct = Struct.new(:weekday, :start_time, :end_time, :type) unless defined?(PeriodStruct)
SHORT_WEEKDAY_FR = %w(lun mar mer jeu ven sam dim) unless defined?(SHORT_WEEKDAY_FR)
WEEKDAYS_EN = %w(monday tuesday wednesday thursday friday saturday sunday) unless defined?(WEEKDAYS_EN)
WEEKDAYS_NB = 7 unless defined?(WEEKDAYS_NB)

describe PeriodBuilder do
  
    WEEKDAYS_NB.times.each do |index|
      short_fr_weekday = SHORT_WEEKDAY_FR[index]
      en_weekday = WEEKDAYS_EN[index]

      describe "when building a period with \"#{short_fr_weekday}\" as a weekday" do
        let(:period_struct) { PeriodStruct.new short_fr_weekday, "0:00", "1:00", "TP" }
        let(:period) { PeriodBuilder.build period_struct }

        it "should build a period with the english weekday \"#{en_weekday}\"" do
          period.weekday.en.should == en_weekday
        end
      end
    end

    describe "when building a course" do
      let(:period_struct) { PeriodStruct.new "lun", "13:00", "14:00", "C" }
      let(:period) { PeriodBuilder.build period_struct }

      it "should build the period with the Cours as the type" do
        period.type.should == "Cours"
      end
    end

    describe "when building a period" do
      let(:period_struct) { PeriodStruct.new "mer", "16:00", "20:00", "Lab" }
      let(:period) { PeriodBuilder.build period_struct }

      it "should build the period with the Lab as the type" do
        period.type.should == "Lab"
      end

      it "should build a period with the appropriate start time" do
        period.start_time.hour.should == 16
        period.start_time.minutes.should == 0
      end

      it "should build a period with the appropriate end time" do
        period.end_time.hour.should == 20
        period.end_time.minutes.should == 0
      end
    end
end
