# -*- encoding : utf-8 -*-
require 'spec_helper'


describe WeekdayTime do
  describe "When creating a weekday time on tuesday at 14:35 (2:35 pm)" do
    let(:tuesday) { Weekday.en "tuesday" }
    let(:time) { WeekdayTime.new(tuesday, 14, 35) }

    specify { time.weekday.should == tuesday }
    specify { time.to_s.should == "14:35" }
    specify { time.hour.should == 14 }
    specify { time.minutes.should == 35 }
    specify { time.to_weekday_i.should == 875 }
    specify { time.to_week_i.should == 2315 }
  end
end
