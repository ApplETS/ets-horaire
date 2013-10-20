# -*- encoding : utf-8 -*-
require_relative "../../app/models/weekday_time"
require_relative "../../app/models/weekday"
require_relative "../../app/models/period"

describe Period do

  describe "When creating a course on monday" do
    let!(:monday) { Weekday.en "monday"}
    before(:each) { Weekday.should_receive(:en).with("monday").and_return(monday) }
    let(:monday_period) { Period::on "monday" }

    specify { monday_period.weekday.should == monday }
    specify { monday_period.type.should be_nil }
    specify { monday_period.start_time.should be_nil }
    specify { monday_period.end_time.should be_nil }
    specify { monday_period.duration.should == 0 }
  end

  describe "When creating a TP on tuesday" do
    let!(:tuesday) { Weekday.en "tuesday"}
    before(:each) { Weekday.should_receive(:en).with("tuesday").and_return(tuesday) }
    let(:tuesday_tp) { Period::on("tuesday").of_type("TP") }

    specify { tuesday_tp.weekday.should == tuesday }
    specify { tuesday_tp.type.should == "TP" }
    specify { tuesday_tp.start_time.should be_nil }
    specify { tuesday_tp.end_time.should be_nil }
    specify { tuesday_tp.duration.should == 0 }
  end

  describe "When creating a Lab on friday from 5h45 to 13h55" do
    let!(:friday) { Weekday.en "friday"}
    let!(:start_time) { WeekdayTime.on(friday).at(5, 45) }
    let!(:end_time) { WeekdayTime.on(friday).at(13, 55) }

    before(:each) do
      Weekday.stub(:en).with("friday").and_return(friday)

      WeekdayTime.should_receive(:on).with(friday).and_return(start_time)
      start_time.should_receive(:at).with(5, 45).and_return(start_time)

      WeekdayTime.should_receive(:on).with(friday).and_return(end_time)
      end_time.should_receive(:at).with(13, 55).and_return(end_time)
    end

    let(:friday_lab) { Period::on("friday").of_type("Lab").from("5:45").to("13:55") }

    specify { friday_lab.weekday.should == friday }
    specify { friday_lab.type.should == "Lab" }
    specify { friday_lab.start_time.should == start_time }
    specify { friday_lab.end_time.should == end_time }
    specify { friday_lab.duration.should == 490 }
  end

  describe "When creating a Cours on wednesday from 6h01 to 6h00" do
    let(:course) { Period::on("wednesday").of_type("Cours").from("6:01").to("6:00") }
    specify { expect { course }.to raise_error "the 'to' method must be called after the 'from' method and be bigger than the latter." }
  end

  describe "When checking for a conflict in a course" do

    describe "When comparing two periods one before the other" do
      let(:first_period) { Period::on("monday").of_type("Cours").from("9:00").to("12:00") }
      let(:second_period) { Period::on("monday").of_type("Lab").from("13:00").to("17:00") }

      it "should not conflict" do
        first_period.conflicts?(second_period).should == false
        second_period.conflicts?(first_period).should == false
      end
    end

    describe "When comparing two intersecting periods" do
      let(:first_period) { Period::on("monday").of_type("TP").from("9:00").to("12:00") }
      let(:second_period) { Period::on("monday").of_type("Lab").from("11:00").to("17:00") }

      it "should conflict" do
        first_period.conflicts?(second_period).should == true
        second_period.conflicts?(first_period).should == true
      end
    end

    describe "When comparing one period contained in another" do
      let(:internal_period) { Period::on("friday").of_type("TP").from("11:00").to("19:00") }
      let(:external_period) { Period::on("friday").of_type("Lab").from("8:00").to("23:00") }

      it "should conflict" do
        internal_period.conflicts?(external_period).should == true
        external_period.conflicts?(internal_period).should == true
      end
    end
    
  end

end
