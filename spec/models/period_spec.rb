require_relative "../../app/models/period"

describe Period do

  describe "when creating a course on monday" do
    let(:period_on_monday) { Period::on "monday", "Cours" }

    it "should return the appropriate int value" do
      period_on_monday.start_time_int.should == 0
    end

    it "should return monday as the weekday" do
      period_on_monday.weekday.should == "monday"
    end

    it "should return Cours as the type" do
      period_on_monday.type.should == "Cours"
    end
  end

  describe "when creating a course on tuesday" do
    let(:period_on_tuesday) { Period::on "tuesday", "TP" }

    it "should return the appropriate int value" do
      period_on_tuesday.end_time_int.should == 1440
    end

    it "should return monday as the weekday" do
      period_on_tuesday.weekday.should == "tuesday"
    end

    it "should return TP as the type" do
      period_on_tuesday.type.should == "TP"
    end
  end

  describe "when creating a course on friday from 5h45 to 13h55" do
    let(:period_on_friday) { Period::on("friday", "Lab").from("5:45").to("13:55") }

    it "should return the appropriate from int value" do
      period_on_friday.start_time_int.should == 6105
    end

    it "should return the appropriate to int value" do
      period_on_friday.end_time_int.should == 6595
    end

    it "should return monday as the weekday" do
      period_on_friday.weekday.should == "friday"
    end

    it "should return Lab as the type" do
      period_on_friday.type.should == "Lab"
    end

    it "should return 5h00 as the start time" do
      period_on_friday.start_time.should == "5:45"
    end

    it "should return 13h00 as the start time" do
      period_on_friday.end_time.should == "13:55"
    end
  end

  describe "when checking for a conflict in a course" do

    describe "when comparing two periods one before the other" do
      let(:first_period) { Period::on("monday", "Cours").from("9:00").to("12:00") }
      let(:second_period) { Period::on("monday", "Cours").from("13:00").to("17:00") }

      it "should not conflict" do
        first_period.conflicts?(second_period).should == false
        second_period.conflicts?(first_period).should == false
      end
    end

    describe "when comparing two intersecting periods" do
      let(:first_period) { Period::on("monday", "Cours").from("9:00").to("12:00") }
      let(:second_period) { Period::on("monday", "Cours").from("11:00").to("17:00") }

      it "should conflict" do
        first_period.conflicts?(second_period).should == true
        second_period.conflicts?(first_period).should == true
      end
    end
    
  end

end