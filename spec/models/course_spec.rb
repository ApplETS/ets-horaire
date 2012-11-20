require_relative "../spec_helper"
require_relative "../../app/models/period"
require_relative "../../app/models/course"
require_relative "../../app/models/group"

describe Course do

  describe "when creating a course" do
    let(:course) { Course.new("LOG640") }

    it "should retain its name" do
      course.name.should == "LOG640"
    end
  end

  describe "when specifying groups in the course" do

    describe "when providing unique group numbers" do
      let(:group_1) { Group.new(1) }
      let(:group_2) { Group.new(2) }
      let(:course) { Course.new("LOG640").with(group_1, group_2) }

      it "should retain the groups" do
        course.groups.should =~ [group_1, group_2]
      end
    end

    describe "when providing duplicate group numbers" do
      let(:group_1) { Group.new(1) }
      let(:group_1_duplicate) { Group.new(1) }

      it "should throw an exception" do
        expect { Course.new("LOG640").with(group_1, group_1_duplicate) }.to raise_error
      end
    end

  end

  describe "when checking for conflicts between courses" do

    describe "when comparing two non-conflicting courses" do
      let(:period_1_1_1) { Period::on("monday").from("15h00").to("17h00") }
      let(:period_1_1_2) { Period::on("friday").from("9h00").to("12h00") }
      let(:group_1_1) { Group.new(1).with(period_1_1_1, period_1_1_2) }
      let(:period_1_2_1) { Period::on("wednesday").from("11h00").to("12h00") }
      let(:period_1_2_2) { Period::on("friday").from("12h01").to("17h00") }
      let(:group_1_2) { Group.new(2).with(period_1_2_1, period_1_2_2) }
      let(:course_1) { Course.new("LOG640").with(group_1_1, group_1_2) }

      let(:period_2_1_1) { Period::on("monday").from("17h01").to("17h02") }
      let(:period_2_1_2) { Period::on("thursday").from("9h00").to("12h00") }
      let(:group_2_1) { Group.new(1).with(period_2_1_1, period_2_1_2) }
      let(:period_2_2_1) { Period::on("friday").from("6h00").to("8h59") }
      let(:period_2_2_2) { Period::on("friday").from("17h01").to("18h00") }
      let(:group_2_2) { Group.new(2).with(period_2_2_1, period_2_2_2) }
      let(:course_2) { Course.new("LOG640").with(group_2_1, group_2_2) }

      it "should not conflict" do
        course_1.conflicts?(course_2).should == false
        course_2.conflicts?(course_1).should == false
      end
    end

    describe "when comparing two conflicting courses" do
      let(:period_1_1_1) { Period::on("monday").from("15h00").to("17h00") }
      let(:period_1_1_2) { Period::on("friday").from("9h00").to("12h00") }
      let(:group_1_1) { Group.new(1).with(period_1_1_1, period_1_1_2) }
      let(:period_1_2_1) { Period::on("wednesday").from("11h00").to("12h00") }
      let(:period_1_2_2) { Period::on("friday").from("12h01").to("17h00") }
      let(:group_1_2) { Group.new(2).with(period_1_2_1, period_1_2_2) }
      let(:course_1) { Course.new("LOG640").with(group_1_1, group_1_2) }

      let(:period_2_1_1) { Period::on("monday").from("17h00").to("17h02") }
      let(:period_2_1_2) { Period::on("thursday").from("9h00").to("12h00") }
      let(:group_2_1) { Group.new(1).with(period_2_1_1, period_2_1_2) }
      let(:period_2_2_1) { Period::on("friday").from("6h00").to("8h59") }
      let(:period_2_2_2) { Period::on("friday").from("17h01").to("18h00") }
      let(:group_2_2) { Group.new(2).with(period_2_2_1, period_2_2_2) }
      let(:course_2) { Course.new("LOG640").with(group_2_1, group_2_2) }

      it "should conflict" do
        course_1.conflicts?(course_2).should == true
        course_2.conflicts?(course_1).should == true
      end
    end

  end

end