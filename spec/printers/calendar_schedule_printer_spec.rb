require_relative "../../app/printers/calendar_schedule_printer"
require_relative "../../app/models/period"

CourseGroupStruct = Struct.new(:course_name, :nb, :periods) unless defined?(CourseGroupStruct)

describe CalendarSchedulePrinter do
  let(:stream) { mock(Object) }

  before(:each) do
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
    let(:course) { Period.on("monday", "Cours").from("8:00").to("11:00") }
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
    let(:course) { Period.on("thursday", "Labo").from("11:10").to("16:17") }
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
    let(:course_1_1) { Period.on("monday", "Cours").from("13:30").to("17:00") }
    let(:course_2_1) { Period.on("thursday", "TP-Labo A").from("13:30").to("15:30") }
    let(:course_3_1) { Period.on("thursday", "TP-Labo B").from("15:30").to("17:00") }
    let(:group_1) { CourseGroupStruct.new "GIA601", 2, [course_1_1, course_2_1, course_3_1] }

    let(:course_1_2) { Period.on("tuesday", "Cours").from("8:45").to("12:15") }
    let(:course_2_2) { Period.on("thursday", "TP").from("8:30").to("10:30") }
    let(:group_2) { CourseGroupStruct.new "GPE450", 1, [course_1_2, course_2_2] }

    let(:course_1_3) { Period.on("wednesday", "Cours").from("18:00").to("21:30") }
    let(:course_2_3) { Period.on("monday", "Labo").from("18:00").to("20:00") }
    let(:group_3) { CourseGroupStruct.new "LOG550", 1, [course_1_3, course_2_3] }

    let(:course_1_4) { Period.on("thursday", "Cours").from("18:00").to("21:30") }
    let(:course_2_4) { Period.on("tuesday", "TP/Labo").from("18:00").to("20:00") }
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
    CalendarSchedulePrinter.print schedule, stream
  end

end