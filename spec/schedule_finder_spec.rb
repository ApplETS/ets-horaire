# -*- encoding : utf-8 -*-
require_relative "support/matchers/conceptual_model_matchers"
require_relative "../app/schedule_finder"
require_relative "../app/models/course"
require_relative "../app/models/group"
require_relative "../app/models/period"

describe ScheduleFinder do

  describe "when finding combinations of possible courses" do
    NB_COURSES = 5
    NB_COURSES.times.each do |courses_per_schedule|
      describe "when providing no courses" do
        let(:schedules) { ScheduleFinder.combinations_for [], courses_per_schedule }

        it "should not find any possible schedules" do
          schedules.should be_empty
        end
      end
    end

    describe "when providing a single course" do
      let(:period_1_5) { Period.on("friday").of_type("Cours").from("6:00").to("7:00") }
      let(:group_5) { Group.new(5).with period_1_5 }

      let(:group_7) { Group.new(7) }

      let(:period_1_8) { Period.on("monday").of_type("Cours").from("6:00").to("7:00") }
      let(:period_2_8) { Period.on("monday").of_type("TP").from("9:00").to("10:00") }
      let(:group_8) { Group.new(8).with period_1_8, period_2_8 }

      let(:course) { Course.new("LOG550").with group_5, group_7, group_8 }
      let(:courses) { [course] }

      describe "when specifying 0 courses per schedule" do
        let(:schedules) { ScheduleFinder.combinations_for courses, 0 }

        it "should not find any possible schedule" do
          schedules.should be_empty
        end
      end

      describe "when specifying 1 course per schedule" do
        let(:schedules) { ScheduleFinder.combinations_for courses, 1 }

        it "should find three possible schedules" do
          schedules.should have_exactly(3).items
        end

        it "should have one period per schedule" do
          schedules.each { |groups| groups.should have_exactly(1).item }
        end

        it "should have the period in the schedules with LOG550 as the course name" do
          schedules.each { |groups| groups.first.course_name.should == "LOG550" }
        end

        it "should find one possible schedule with group 5" do
          schedules.should conceptually_include(group_5)
        end

        it "should find one possible schedule with group 7" do
          schedules.should conceptually_include(group_7)
        end

        it "should find one possible schedule with group 8" do
          schedules.should conceptually_include(group_8)
        end
      end

      describe "when specifying 2 courses per schedule" do
        let(:schedules) { ScheduleFinder.combinations_for courses, 2 }

        it "should not find any possible schedule" do
          schedules.should be_empty
        end
      end
    end

    describe "when providing multiple courses" do
      # COM110
      let(:period_1_1_1) { Period.on("thursday").of_type("Cours").from("9:00").to("12:30") }
      let(:period_2_1_1) { Period.on("tuesday").of_type("TP").from("8:30").to("12:30") }
      let(:group_1_1) { Group.new(1).with period_1_1_1, period_2_1_1 }

      let(:period_1_2_1) { Period.on("wednesday").of_type("Cours").from("9:00").to("12:30") }
      let(:period_2_2_1) { Period.on("monday").of_type("TP").from("8:30").to("12:30") }
      let(:group_2_1) { Group.new(2).with period_1_2_1, period_2_2_1 }

      let(:period_1_3_1) { Period.on("monday").of_type("Cours").from("18:00").to("21:30") }
      let(:period_2_3_1) { Period.on("wednesday").of_type("TP").from("18:00").to("22:00") }
      let(:group_3_1) { Group.new(3).with period_1_3_1, period_2_3_1 }

      let(:period_1_4_1) { Period.on("wednesday").of_type("Cours").from("13:30").to("17:00") }
      let(:period_2_4_1) { Period.on("friday").of_type("TP").from("8:30").to("12:30") }
      let(:group_4_1) { Group.new(4).with period_1_4_1, period_2_4_1 }

      let(:period_1_5_1) { Period.on("thursday").of_type("Cours").from("18:00").to("21:30") }
      let(:period_2_5_1) { Period.on("tuesday").of_type("TP").from("18:00").to("22:00") }
      let(:group_5_1) { Group.new(5).with period_1_5_1, period_2_5_1 }

      let(:course_1) { Course.new("COM110").with group_1_1, group_2_1, group_3_1, group_4_1, group_5_1 }

      # LOG320
      let(:period_1_1_2) { Period.on("friday").of_type("Cours").from("13:00").to("17:00") }
      let(:period_2_1_2) { Period.on("tuesday").of_type("TP").from("13:00").to("17:00") }
      let(:group_1_2) { Group.new(1).with period_1_1_2, period_2_1_2 }

      let(:course_2) { Course.new("LOG320").with group_1_2 }

      # LOG330
      let(:period_1_1_3) { Period.on("thursday").of_type("Cours").from("18:00").to("21:00") }
      let(:period_2_1_3) { Period.on("friday").of_type("TP").from("18:00").to("20:00") }
      let(:group_1_3) { Group.new(1).with period_1_1_3, period_2_1_3 }

      let(:period_1_2_3) { Period.on("monday").of_type("Cours").from("18:00").to("21:00") }
      let(:period_2_2_3) { Period.on("tuesday").of_type("TP").from("9:00").to("12:00") }
      let(:group_2_3) { Group.new(2).with period_1_2_3, period_2_2_3 }

      let(:course_3) { Course.new("LOG330").with group_1_3, group_2_3 }

      # GIA400
      let(:period_1_1_4) { Period.on("tuesday").of_type("Cours").from("18:00").to("21:00") }
      let(:period_2_1_4) { Period.on("friday").of_type("TP").from("9:00").to("12:00") }
      let(:group_1_4) { Group.new(1).with period_1_1_4, period_2_1_4 }

      let(:period_1_2_4) { Period.on("friday").of_type("Cours").from("13:00").to("17:00") }
      let(:period_2_2_4) { Period.on("monday").of_type("TP").from("13:00").to("17:00") }
      let(:group_2_4) { Group.new(2).with period_1_2_4, period_2_2_4 }

      let(:period_1_3_4) { Period.on("wednesday").of_type("Cours").from("9:00").to("12:00") }
      let(:period_2_3_4) { Period.on("monday").of_type("TP").from("9:00").to("12:00") }
      let(:group_3_4) { Group.new(3).with period_1_3_4, period_2_3_4 }

      let(:course_4) { Course.new("GIA400").with group_1_4, group_2_4, group_3_4 }

      # Courses
      let(:courses) { [course_1, course_2, course_3, course_4] }

      describe "when specifying 4 courses per schedule" do
        let(:schedules) { ScheduleFinder.combinations_for courses, 4 }

        it "should find all 9 possibilities" do
          schedules.should have_exactly(9).times

          schedules.should conceptually_include(group_1_2, group_1_1, group_1_3, group_1_4)
          schedules.should conceptually_include(group_1_2, group_1_1, group_1_3, group_3_4)
          schedules.should conceptually_include(group_1_2, group_2_1, group_1_3, group_1_4)
          schedules.should conceptually_include(group_1_2, group_2_1, group_2_3, group_1_4)
          schedules.should conceptually_include(group_1_2, group_3_1, group_1_3, group_1_4)
          schedules.should conceptually_include(group_1_2, group_3_1, group_1_3, group_3_4)
          schedules.should conceptually_include(group_1_2, group_4_1, group_1_3, group_3_4)
          schedules.should conceptually_include(group_1_2, group_4_1, group_2_3, group_3_4)
          schedules.should conceptually_include(group_1_2, group_5_1, group_2_3, group_3_4)
        end
      end
    end
  end

end
