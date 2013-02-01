require_relative "../../app/models/weekday"
require_relative "../../app/models/weekday_time"

describe WeekdayTime do
  describe "When creating a weekday time on friday" do
    let(:friday) { Weekday.en "friday" }
    let(:time) { WeekdayTime.on friday }

    specify { time.weekday.should == friday }
    specify { time.to_s.should == "00:00" }
    specify { time.to_weekday_i.should == 0 }
    specify { time.to_week_i.should == 5760 }
  end

  describe "When creating a weekday time on tuesday at 9:35" do
    let(:tuesday) { Weekday.en "tuesday" }
    let(:time) { WeekdayTime.on(tuesday).at("9:35") }

    specify { time.weekday.should == tuesday }
    specify { time.to_s.should == "9:35" }
    specify { time.to_weekday_i.should == 575 }
    specify { time.to_week_i.should == 2015 }
  end
end