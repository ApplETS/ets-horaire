require_relative "../../app/builders/period_builder"

PeriodStruct = Struct.new(:weekday, :start_time, :end_time, :type)
SHORT_WEEKDAY_FR = %w(lun mar mer jeu ven sam dim)
WEEKDAYS_EN = %w(monday tuesday wednesday thursday friday saturday sunday)
WEEKDAYS_NB = 7

describe PeriodBuilder do
  
    WEEKDAYS_NB.times.each do |index|
      short_fr_weekday = SHORT_WEEKDAY_FR[index]
      en_weekday = WEEKDAYS_EN[index]

      describe "when building a period with \"#{short_fr_weekday}\" as a weekday" do
        let(:period_struct) { PeriodStruct.new short_fr_weekday, "0h00", "1h00", "TP" }
        let(:period) { mock(Object) }

        before(:each) do
          period.stub!(:from).and_return(period)
          period.stub!(:to)
        end

        it "should build a period with the english weekday \"#{en_weekday}\"" do
          Period.should_receive(:on).once.and_return(period)
        end
      end
    end

    describe "when building a period" do
      let(:period_struct) { PeriodStruct.new "mer", "16h00", "20h00", "Cours" }
      let(:period) { mock(Object) }

      before(:each) do
        Period.stub!(:on).and_return(period)
        period.stub!(:from).and_return(period)
        period.stub!(:to)
      end

      it "should build a period with the appropriate start time" do
        period.should_receive(:from).once.with("16h00")
      end

      it "should build a period with the appropriate end time" do
        period.should_receive(:to).once.with("20h00")
      end
    end

    after(:each) { PeriodBuilder.build period_struct }
end