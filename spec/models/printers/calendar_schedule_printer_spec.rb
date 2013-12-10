# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CalendarSchedulePrinter do
  CourseGroupStruct = Struct.new(:course_name, :nb, :periods)

  let(:stream) { double("Stream") }

  before(:each) do
    File.stub(:open).with("output_file", "w").and_yield stream

    stream.should_receive(:write).once.with "*******************************************************************************************\n"
    stream.should_receive(:write).once.with "*******************************************************************************************\n\n"
    stream.should_receive(:write).once.with "     --------------------------------------------------------------------------------------\n"
    stream.should_receive(:write).once.with "     |Lundi           |Mardi           |Mercredi        |Jeudi           |Vendredi        |\n"
    stream.should_receive(:write).once.with "     --------------------------------------------------------------------------------------\n"
  end

  describe "when printing any schedule" do
    let(:schedule) { [] }

    it "should print the header containing the days and print the hours on the side (from 8:00 to 23:00)" do
      stream.should_receive(:write).once.with /08:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /09:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /10:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /11:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /12:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /13:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /14:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /15:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /16:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /17:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /18:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /19:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /20:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /21:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /22:00|................|................|................|................|................|\n/
      stream.should_receive(:write).once.with /23:00|................|................|................|................|................|\n/
    end
  end

  describe "when printing a schedule with a GIA400 course, in group 2, from 8:00 to 11:00, on monday" do
    let(:course) { Period.new(Weekday.en("monday"), "Cours", WeekdayTime.new(Weekday.en("monday"), 8, 00), WeekdayTime.new(Weekday.en("monday"), 11, 00)) }
    let(:group) { CourseGroupStruct.new "GIA400", 2, [course] }
    let(:schedule) { [group] }

    it "should only print the course on the schedule" do
      stream.should_receive(:write).once.with "08:00|00--------------|                |                |                |                |\n"
      stream.should_receive(:write).once.with "09:00|GIA400-02      C|                |                |                |                |\n"
      stream.should_receive(:write).once.with "10:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "11:00|--------------00|                |                |                |                |\n"
      stream.should_receive(:write).once.with "12:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "13:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "14:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "15:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "16:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "17:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "18:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "19:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "20:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "21:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "22:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "23:00|                |                |                |                |                |\n"
    end
  end

  describe "when printing a schedule with a LOG120 labcourse, in group 3, from 11:10 to 16:17, on thursday" do
    let(:course) { Period.new(Weekday.en("thursday"), "Labo", WeekdayTime.new(Weekday.en("thursday"), 11, 10), WeekdayTime.new(Weekday.en("thursday"), 16, 17)) }
    let(:group) { CourseGroupStruct.new "LOG120", 3, [course] }
    let(:schedule) { [group] }

    it "should only print the course on the schedule" do
      stream.should_receive(:write).once.with "08:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "09:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "10:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "11:00|                |                |                |10--------------|                |\n"
      stream.should_receive(:write).once.with "12:00|                |                |                |LOG120-03      L|                |\n"
      stream.should_receive(:write).once.with "13:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "14:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "15:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "16:00|                |                |                |--------------17|                |\n"
      stream.should_receive(:write).once.with "17:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "18:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "19:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "20:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "21:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "22:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "23:00|                |                |                |                |                |\n"
    end
  end

  describe "when printing a complicated schedule" do
    let(:course_1_1) { Period.new(Weekday.en("monday"), "Cours", WeekdayTime.new(Weekday.en("monday"), 13, 30), WeekdayTime.new(Weekday.en("monday"), 17, 00)) }
    let(:course_2_1) { Period.new(Weekday.en("thursday"), "TP-Labo A", WeekdayTime.new(Weekday.en("thursday"), 13, 30), WeekdayTime.new(Weekday.en("thursday"), 15, 30)) }
    let(:course_3_1) { Period.new(Weekday.en("thursday"), "TP-Labo B", WeekdayTime.new(Weekday.en("thursday"), 15, 30), WeekdayTime.new(Weekday.en("thursday"), 17, 00)) }
    let(:group_1) { CourseGroupStruct.new "GIA601", 2, [course_1_1, course_2_1, course_3_1] }

    let(:course_1_2) { Period.new(Weekday.en("tuesday"), "Cours", WeekdayTime.new(Weekday.en("tuesday"), 8, 45), WeekdayTime.new(Weekday.en("tuesday"), 12, 15)) }
    let(:course_2_2) { Period.new(Weekday.en("thursday"), "TP", WeekdayTime.new(Weekday.en("thursday"), 8, 30), WeekdayTime.new(Weekday.en("thursday"), 10, 30)) }
    let(:group_2) { CourseGroupStruct.new "GPE450", 1, [course_1_2, course_2_2] }

    let(:course_1_3) { Period.new(Weekday.en("wednesday"), "Cours", WeekdayTime.new(Weekday.en("wednesday"), 18, 00), WeekdayTime.new(Weekday.en("wednesday"), 21, 30)) }
    let(:course_2_3) { Period.new(Weekday.en("monday"), "Labo", WeekdayTime.new(Weekday.en("monday"), 18, 00), WeekdayTime.new(Weekday.en("monday"), 20, 00)) }
    let(:group_3) { CourseGroupStruct.new "LOG550", 1, [course_1_3, course_2_3] }

    let(:course_1_4) { Period.new(Weekday.en("thursday"), "Cours", WeekdayTime.new(Weekday.en("thursday"), 18, 00), WeekdayTime.new(Weekday.en("thursday"), 21, 30)) }
    let(:course_2_4) { Period.new(Weekday.en("tuesday"), "TP/Labo", WeekdayTime.new(Weekday.en("tuesday"), 18, 00), WeekdayTime.new(Weekday.en("tuesday"), 20, 00)) }
    let(:group_4) { CourseGroupStruct.new "LOG619", 1, [course_1_4, course_2_4] }

    let(:schedule) { [group_1, group_2, group_3, group_4] }

    it "should only print the course on the schedule" do
      stream.should_receive(:write).once.with "08:00|                |45--------------|                |30--------------|                |\n"
      stream.should_receive(:write).once.with "09:00|                |GPE450-01      C|                |GPE450-01      T|                |\n"
      stream.should_receive(:write).once.with "10:00|                |                |                |--------------30|                |\n"
      stream.should_receive(:write).once.with "11:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "12:00|                |--------------15|                |                |                |\n"
      stream.should_receive(:write).once.with "13:00|30--------------|                |                |30--------------|                |\n"
      stream.should_receive(:write).once.with "14:00|GIA601-02      C|                |                |GIA601-02  T-L A|                |\n"
      stream.should_receive(:write).once.with "15:00|                |                |                |30------------30|                |\n"
      stream.should_receive(:write).once.with "16:00|                |                |                |GIA601-02  T-L B|                |\n"
      stream.should_receive(:write).once.with "17:00|--------------00|                |                |--------------00|                |\n"
      stream.should_receive(:write).once.with "18:00|00--------------|00--------------|00--------------|00--------------|                |\n"
      stream.should_receive(:write).once.with "19:00|LOG550-01      L|LOG619-01    T/L|LOG550-01      C|LOG619-01      C|                |\n"
      stream.should_receive(:write).once.with "20:00|--------------00|--------------00|                |                |                |\n"
      stream.should_receive(:write).once.with "21:00|                |                |--------------30|--------------30|                |\n"
      stream.should_receive(:write).once.with "22:00|                |                |                |                |                |\n"
      stream.should_receive(:write).once.with "23:00|                |                |                |                |                |\n"
    end
  end

  after(:each) do
    stream.should_receive(:write).once.with "     --------------------------------------------------------------------------------------\n"
    stream.should_receive(:write).once.with "\n"
    CalendarSchedulePrinter.output [schedule], "output_file"
  end

end
