require_relative "../spec_helper"
require_relative "../../app/models/group"

describe Group do

  describe "when creating a group with specific periods" do
    let(:lecture) { Period::on("monday").from("18h00").to("21h00") }
    let(:practical_work) { Period::on("friday").from("18h00").to("21h00") }
    let(:group) { Group.new(1).with lecture, practical_work }

    it "should return the appropriate periods" do
      group.periods.should =~ [lecture, practical_work]
    end
  end

  describe "when checking for conflicting periods" do

    describe "when comparing two groups that have no conflicting periods" do
      let(:lecture_1) { Period::on("monday").from("18h00").to("21h00") }
      let(:practical_work_1) { Period::on("friday").from("18h00").to("21h00") }
      let(:group_1) { Group.new(1).with lecture_1, practical_work_1 }

      let(:lecture_2) { Period::on("monday").from("9h00").to("12h00") }
      let(:practical_work_2) { Period::on("friday").from("9h00").to("12h00") }
      let(:group_2) { Group.new(2).with lecture_2, practical_work_2 }

      it "should not conflict" do
        group_1.conflicts?(group_2).should == false
        group_2.conflicts?(group_1).should == false
      end
    end

    describe "when comparing two groups that have conflicting periods" do
      let(:lecture_1) { Period::on("monday").from("18h00").to("21h00") }
      let(:practical_work_1) { Period::on("friday").from("18h00").to("21h00") }
      let(:group_1) { Group.new(1).with lecture_1, practical_work_1 }

      let(:lecture_2) { Period::on("monday").from("16h00").to("19h00") }
      let(:practical_work_2) { Period::on("friday").from("9h00").to("12h00") }
      let(:group_2) { Group.new(2).with lecture_2, practical_work_2 }

      it "should conflict" do
        group_1.conflicts?(group_2).should == true
        group_2.conflicts?(group_1).should == true
      end
    end

  end

end