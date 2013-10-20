# -*- encoding : utf-8 -*-
require 'spec_helper'


describe WeekdayTime do
  describe "When creating a weekday time on friday" do
    let(:friday) { Weekday.en "friday" }
    let(:time) { WeekdayTime.on friday }

    specify { time.weekday.should == friday }
    specify { time.to_s.should == "00:00" }
    specify { time.hour.should == 0 }
    specify { time.minutes.should == 0 }
    specify { time.to_weekday_i.should == 0 }
    specify { time.to_week_i.should == 5760 }
  end

  describe "When creating a weekday time on tuesday at 14:35 (2:35 pm)" do
    let(:tuesday) { Weekday.en "tuesday" }
    let(:time) { WeekdayTime.on(tuesday).at(14, 35) }

    specify { time.weekday.should == tuesday }
    specify { time.to_s.should == "14:35" }
    specify { time.hour.should == 14 }
    specify { time.minutes.should == 35 }
    specify { time.to_weekday_i.should == 875 }
    specify { time.to_week_i.should == 2315 }
  end
end
