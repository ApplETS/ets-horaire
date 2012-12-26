require_relative "../../app/models/period"

describe Period do

  describe "when creating a course on monday" do
    let(:period_on_monday) { Period::on "monday" }

    it "should return the appropriate int value" do
      period_on_monday.start_time_int.should == 0
    end

    it "shoud return monday as the weekday" do
      period_on_monday.weekday.should == "monday"
    end
  end

  describe "when creating a course on tuesday" do
    let(:period_on_tuesday) { Period::on "tuesday" }

    it "should return the appropriate int value" do
      period_on_tuesday.end_time_int.should == 1440
    end

    it "shoud return monday as the weekday" do
      period_on_tuesday.weekday.should == "tuesday"
    end
  end

  describe "when creating a course on friday from 5h00 to 13h00" do
    let(:period_on_friday) { Period::on("friday").from("5h00").to("13h00") }

    it "should return the appropriate from int value" do
      period_on_friday.start_time_int.should == 6060
    end

    it "should return the appropriate to int value" do
      period_on_friday.end_time_int.should == 6540
    end

    it "shoud return monday as the weekday" do
      period_on_friday.weekday.should == "friday"
    end

    it "should return 5h00 as the start time" do
      period_on_friday.start_time.should == "5h00"
    end

    it "should return 13h00 as the start time" do
      period_on_friday.end_time.should == "13h00"
    end
  end

  describe "when checking for a conflict in a course" do

    describe "when comparing two periods one before the other" do
      let(:first_period) { Period::on("monday").from("9h00").to("12h00") }
      let(:second_period) { Period::on("monday").from("13h00").to("17h00") }

      it "should not conflict" do
        first_period.conflicts?(second_period).should == false
        second_period.conflicts?(first_period).should == false
      end
    end

    describe "when comparing two intersecting periods" do
      let(:first_period) { Period::on("monday").from("9h00").to("12h00") }
      let(:second_period) { Period::on("monday").from("11h00").to("17h00") }

      it "should conflict" do
        first_period.conflicts?(second_period).should == true
        second_period.conflicts?(first_period).should == true
      end
    end
    
  end

end