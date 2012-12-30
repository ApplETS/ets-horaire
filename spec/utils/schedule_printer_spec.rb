require_relative "../../app/utils/schedule_printer"
require_relative "../../app/models/period"

describe SchedulePrinter do

  Group = Struct.new(:course_name, :nb, :periods)

  let(:stream) { mock(Object) }

  before(:each) do
    stream.should_receive(:write).once.with "     --------------------------------------------------------------------------------------"
    stream.should_receive(:write).once.with "     |Lundi           |Mardi           |Mercredi        |Jeudi           |Vendredi        |"
    stream.should_receive(:write).once.with "     --------------------------------------------------------------------------------------"
  end

  describe "when printing any schedule" do
    let(:schedule) { [] }

    it "should print the header containing the days and print the hours on the side (from 8:00 to 23:00)" do
      stream.should_receive(:write).once.with /08:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /09:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /10:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /11:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /12:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /13:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /14:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /15:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /16:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /17:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /18:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /19:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /20:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /21:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /22:00|................|................|................|................|................|/
      stream.should_receive(:write).once.with /23:00|................|................|................|................|................|/
    end
  end

  describe "when printing a schedule with a GIA400 course, in group 2, from 8:00 to 11:00, on monday" do
    let(:course) { Period.on("monday", "Cours").from("8:00").to("11:00") }
    let(:group) { Group.new "GIA400", 2, [course] }
    let(:schedule) { [group] }

    it "should only print the course on the schedule" do
      stream.should_receive(:write).once.with "08:00|00--------------|                |                |                |                |"
      stream.should_receive(:write).once.with "09:00|GIA400-02      C|                |                |                |                |"
      stream.should_receive(:write).once.with "10:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "11:00|--------------00|                |                |                |                |"
      stream.should_receive(:write).once.with "12:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "13:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "14:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "15:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "16:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "17:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "18:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "19:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "20:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "21:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "22:00|                |                |                |                |                |"
      stream.should_receive(:write).once.with "23:00|                |                |                |                |                |"
    end
  end

  after(:each) do
    stream.should_receive(:write).once.with "     --------------------------------------------------------------------------------------"
    SchedulePrinter.print schedule, stream
  end

end