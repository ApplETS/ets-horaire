# -*- encoding : utf-8 -*-
require_relative "../../app/models/period"
require_relative "../../app/models/course_group"

describe CourseGroup do

  describe "when creating a group" do
    let(:group) { CourseGroup.new("LOG640", 2) }

    it "should have LOG640 as the course name" do
      group.course_name.should == "LOG640"
    end

    it "should have 2 as the group number" do
      group.nb.should == 2
    end
  end

  describe "when checking for conflicting periods" do
    describe "when comparing two groups that have no conflicting periods" do
      let(:lecture_1) { Period.on("monday").of_type("Cours").from("18:00").to("21:00") }
      let(:practical_work_1) { Period.on("friday").of_type("TP").from("18:00").to("21:00") }

      let(:lecture_2) { Period.on("monday").of_type("Cours").from("9:00").to("12:00") }
      let(:practical_work_2) { Period.on("friday").of_type("TP").from("9:00").to("12:00") }

      describe "when the groups have course names that differ" do
        let(:group_1) { CourseGroup.new("LOG320", 1).with lecture_1, practical_work_1 }
        let(:group_2) { CourseGroup.new("LOG330", 2).with lecture_2, practical_work_2 }

        it "should not conflict" do
          group_1.conflicts?(group_2).should == false
          group_2.conflicts?(group_1).should == false
        end
      end

      describe "when the groups have the same course names" do
        let(:group_1) { CourseGroup.new("ING500", 1).with lecture_1, practical_work_1 }
        let(:group_2) { CourseGroup.new("ING500", 2).with lecture_2, practical_work_2 }

        it "should conflict" do
          group_1.conflicts?(group_2).should == true
          group_2.conflicts?(group_1).should == true
        end
      end
    end

    describe "when comparing two groups that have conflicting periods" do
      let(:conflicting_lecture_1) { Period.on("monday").of_type("Cours").from("18:00").to("21:00") }
      let(:practical_work_1) { Period.on("friday").of_type("TP").from("18:00").to("21:00") }
      let(:group_1) { CourseGroup.new("LOG550", 1).with conflicting_lecture_1, practical_work_1 }

      let(:conflicting_lecture_2) { Period.on("monday").of_type("Cours").from("16:00").to("19:00") }
      let(:practical_work_2) { Period.on("friday").of_type("TP").from("9:00").to("12:00") }
      let(:group_2) { CourseGroup.new("GIA400", 2).with conflicting_lecture_2, practical_work_2 }

      it "should conflict" do
        group_1.conflicts?(group_2).should == true
        group_2.conflicts?(group_1).should == true
      end
    end
  end
end
