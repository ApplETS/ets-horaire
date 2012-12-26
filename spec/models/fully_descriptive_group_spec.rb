require_relative "../../app/models/period"
require_relative "../../app/models/fully_descriptive_group"

describe FullyDescriptiveGroup do

  describe "when creating a group" do
    let(:group) { FullyDescriptiveGroup.new("LOG640", 2) }

    it "should have LOG640 as the course name" do
      group.course_name.should == "LOG640"
    end
  end

  describe "when checking for conflicting periods" do
    describe "when comparing two groups that have no conflicting periods" do
      let(:lecture_1) { Period.on("monday").from("18h00").to("21h00") }
      let(:practical_work_1) { Period.on("friday").from("18h00").to("21h00") }

      let(:lecture_2) { Period.on("monday").from("9h00").to("12h00") }
      let(:practical_work_2) { Period.on("friday").from("9h00").to("12h00") }

      describe "when the groups have course names that differ" do
        let(:group_1) { FullyDescriptiveGroup.new("LOG320", 1).with lecture_1, practical_work_1 }
        let(:group_2) { FullyDescriptiveGroup.new("LOG330", 2).with lecture_2, practical_work_2 }

        it "should not conflict" do
          group_1.conflicts?(group_2).should == false
          group_2.conflicts?(group_1).should == false
        end
      end

      describe "when the groups have the same course names" do
        let(:group_1) { FullyDescriptiveGroup.new("ING500", 1).with lecture_1, practical_work_1 }
        let(:group_2) { FullyDescriptiveGroup.new("ING500", 2).with lecture_2, practical_work_2 }

        it "should conflict" do
          group_1.conflicts?(group_2).should == true
          group_2.conflicts?(group_1).should == true
        end
      end
    end

    describe "when comparing two groups that have conflicting periods" do
      let(:conflicting_lecture_1) { Period.on("monday").from("18h00").to("21h00") }
      let(:practical_work_1) { Period.on("friday").from("18h00").to("21h00") }
      let(:group_1) { FullyDescriptiveGroup.new("LOG550", 1).with conflicting_lecture_1, practical_work_1 }

      let(:conflicting_lecture_2) { Period.on("monday").from("16h00").to("19h00") }
      let(:practical_work_2) { Period.on("friday").from("9h00").to("12h00") }
      let(:group_2) { FullyDescriptiveGroup.new("GIA400", 2).with conflicting_lecture_2, practical_work_2 }

      it "should conflict" do
        group_1.conflicts?(group_2).should == true
        group_2.conflicts?(group_1).should == true
      end
    end
  end
end