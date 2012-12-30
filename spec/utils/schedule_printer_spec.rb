require_relative "../../app/utils/schedule_printer"

WEEKDAYS = %w(lundi mardi mercredi jeudi vendredi samedi dimanche)

describe SchedulePrinter do

  describe "when printing any schedule" do
    let(:stream) { mock(Object) }
    let(:schedule) { [] }

    it "should print the header containing the days" do
      stream.should_receive(:write).once.with "     -------------------------------------------------------------------------------------"
      stream.should_receive(:write).once.with "     |Lundi          ||Mardi          ||Mercredi       ||Jeudi          ||Vendredi       |"
      stream.should_receive(:write).once.with "     -------------------------------------------------------------------------------------"
      SchedulePrinter.print schedule, stream
    end

    it "should print the hours on the side" do
      stream.should_receive(:write).exactly(3).times
      SchedulePrinter.print schedule, stream
    end

    it "should print a ending line to close the schedule" do
      stream.should_receive(:write).exactly(19).times
      stream.should_receive(:write).once.with "     -------------------------------------------------------------------------------------"
      SchedulePrinter.print schedule, stream
    end

  end

end