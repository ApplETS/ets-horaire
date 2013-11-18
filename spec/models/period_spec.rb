# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Period do
  describe "When creating a Lab on friday" do
    let(:friday) { double(Weekday) }
    let(:start_time) { double(WeekdayTime) }
    let(:end_time) { double(WeekdayTime) }
    let(:lab) { Period.new(friday, "Lab", start_time, end_time) }

    specify { lab.weekday.should eq(friday) }
    specify { lab.type.should eq("Lab") }
    specify { lab.start_time.should eq(start_time) }
    specify { lab.end_time.should eq(end_time) }
  end

  describe :duration do
    let(:monday) { double(Weekday) }
    let(:start_time) { double(WeekdayTime, to_weekday_i: 200) }
    let(:end_time) { double(WeekdayTime, to_weekday_i: 750) }
    let(:cours) { Period.new(monday, "Cours", start_time, end_time) }

    specify { cours.duration.should eq(550) }
  end

  describe :conflicts? do
    describe "When comparing two periods one before the other" do
      let(:tuesday) { double(Weekday) }

      let(:first_period_start_time) { double(WeekdayTime, to_week_i: 200) }
      let(:first_period_end_time) { double(WeekdayTime, to_week_i: 500) }
      let(:first_period) { Period.new(tuesday, "Cours", first_period_start_time, first_period_end_time) }

      let(:second_period_start_time) { double(WeekdayTime, to_week_i: 550) }
      let(:second_period_end_time) { double(WeekdayTime, to_week_i: 1250) }
      let(:second_period) { Period.new(tuesday, "Cours", second_period_start_time, second_period_end_time) }

      specify do
        first_period.conflicts?(second_period).should be_false
        second_period.conflicts?(first_period).should be_false
      end
    end

    describe "When comparing two intersecting periods" do
      let(:tuesday) { double(Weekday) }

      let(:first_period_start_time) { double(WeekdayTime, to_week_i: 0) }
      let(:first_period_end_time) { double(WeekdayTime, to_week_i: 1000) }
      let(:first_period) { Period.new(tuesday, "Cours", first_period_start_time, first_period_end_time) }

      let(:second_period_start_time) { double(WeekdayTime, to_week_i: 500) }
      let(:second_period_end_time) { double(WeekdayTime, to_week_i: 1500) }
      let(:second_period) { Period.new(tuesday, "Cours", second_period_start_time, second_period_end_time) }

      specify do
        first_period.conflicts?(second_period).should be_true
        second_period.conflicts?(first_period).should be_true
      end
    end

    describe "When comparing one period contained in another" do
      let(:tuesday) { double(Weekday) }

      let(:first_period_start_time) { double(WeekdayTime, to_week_i: 0) }
      let(:first_period_end_time) { double(WeekdayTime, to_week_i: 1500) }
      let(:external_period) { Period.new(tuesday, "Cours", first_period_start_time, first_period_end_time) }

      let(:second_period_start_time) { double(WeekdayTime, to_week_i: 500) }
      let(:second_period_end_time) { double(WeekdayTime, to_week_i: 1000) }
      let(:internal_period) { Period.new(tuesday, "Cours", second_period_start_time, second_period_end_time) }

      specify do
        external_period.conflicts?(internal_period).should be_true
        internal_period.conflicts?(external_period).should be_true
      end
    end
  end

end
