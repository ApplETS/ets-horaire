# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GroupBuilder do
  GroupStruct = Struct.new(:nb, :periods)
  PeriodStruct = Struct.new(:weekday, :start_time, :end_time, :type)

  describe "when building a group with no periods" do
    let(:group_struct) { GroupStruct.new 6, [] }
    let(:group) { GroupBuilder.build group_struct }

    it "should match the group struct number" do
      group.nb.should == 6
    end

    it "should have no periods" do
      group.periods.should be_empty
    end
  end

  describe "when building an elaborate group" do
    let(:period_struct_1) { PeriodStruct.new("lun", "16:00", "23:00", "Cours") }
    let(:period_struct_2) { PeriodStruct.new("mar", "9:00", "9:05", "TP") }
    let(:period_struct_3) { PeriodStruct.new("ven", "8:00", "21:00", "Lab") }
    let(:period_struct_4) { PeriodStruct.new("sam", "11:34", "12:39", "Cours") }
    let(:group_struct) { GroupStruct.new 12, [period_struct_1, period_struct_2, period_struct_3, period_struct_4] }

    let(:group) { GroupBuilder.build group_struct }

    let(:period_1) { group.periods[0] }
    let(:period_2) { group.periods[1] }
    let(:period_3) { group.periods[2] }
    let(:period_4) { group.periods[3] }

    it "should have 12 as its group number" do
      group.nb.should == 12
    end

    it "should have 4 periods" do
      group.periods.should have_exactly(4).times
    end

    it "should have its first period on monday" do
      period_1.weekday.en.should == "monday"
    end

    it "should have its first period as a Cours type" do
      period_1.type.should == "Cours"
    end

    it "should have its first period from 16h" do
      period_1.start_time.hour.should == 16
      period_1.start_time.minutes.should == 0
    end

    it "should have its first period to 23h" do
      period_1.end_time.hour.should == 23
      period_1.end_time.minutes.should == 0
    end

    it "should have its second period on tuesday" do
      period_2.weekday.en.should == "tuesday"
    end

    it "should have its first period as a TP type" do
      period_2.type.should == "TP"
    end

    it "should have its second period from 9h" do
      period_2.start_time.hour.should == 9
      period_2.start_time.minutes.should == 0
    end

    it "should have its second period to 9:05" do
      period_2.end_time.hour.should == 9
      period_2.end_time.minutes.should == 5
    end

    it "should have its third period on friday" do
      period_3.weekday.en.should == "friday"
    end

    it "should have its first period as a Lab type" do
      period_3.type.should == "Lab"
    end

    it "should have its third period from 8h" do
      period_3.start_time.hour.should == 8
      period_3.start_time.minutes.should == 0
    end

    it "should have its third period to 21h" do
      period_3.end_time.hour.should == 21
      period_3.end_time.minutes.should == 0
    end

    it "should have its fourth period on saturday" do
      period_4.weekday.en.should == "saturday"
    end

    it "should have its first period as a Cours type" do
      period_4.type.should == "Cours"
    end

    it "should have its fourth period from 11:34" do
      period_4.start_time.hour.should == 11
      period_4.start_time.minutes.should == 34
    end

    it "should have its fourth period to 12:39" do
      period_4.end_time.hour.should == 12
      period_4.end_time.minutes.should == 39
    end
  end

end
