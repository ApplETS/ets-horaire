require_relative "../spec_helper"
require_relative "../../app/models/period"

describe Period do

  describe "when creating a course on monday" do
    let(:period_on_monday) { Period::on "monday" }

    it "should return the appropriate int value" do
      period_on_monday.from_time.should == 0
    end
  end

  describe "when creating a course on tuesday" do
    let(:period_on_tuesday) { Period::on "tuesday" }

    it "should return the appropriate int value" do
      period_on_tuesday.to_time.should == 1440
    end
  end

  describe "when creating a course on friday from 5h00 to 13h00" do
    let(:period_on_friday) { Period::on("friday").from("5h00").to("13h00") }

    it "should return the appropriate from int value" do
      period_on_friday.from_time.should == 6060
    end

    it "should return the appropriate to int value" do
      period_on_friday.to_time.should == 6540
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