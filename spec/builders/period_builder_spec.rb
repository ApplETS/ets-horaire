require_relative "../../app/builders/period_builder"

PeriodStruct = Struct.new(:weekday, :start_time, :end_time, :type) if !defined?(PeriodStruct)
SHORT_WEEKDAY_FR = %w(lun mar mer jeu ven sam dim)
WEEKDAYS_EN = %w(monday tuesday wednesday thursday friday saturday sunday)
WEEKDAYS_NB = 7

describe PeriodBuilder do
  
    WEEKDAYS_NB.times.each do |index|
      short_fr_weekday = SHORT_WEEKDAY_FR[index]
      en_weekday = WEEKDAYS_EN[index]

      describe "when building a period with \"#{short_fr_weekday}\" as a weekday" do
        let(:period_struct) { PeriodStruct.new short_fr_weekday, "0h00", "1h00", "TP" }
        let(:period) { PeriodBuilder.build period_struct }

        it "should build a period with the english weekday \"#{en_weekday}\"" do
          period.weekday.should == en_weekday
        end
      end
    end

    describe "when building a period" do
      let(:period_struct) { PeriodStruct.new "mer", "16h00", "20h00", "Cours" }
      let(:period) { PeriodBuilder.build period_struct }

      it "should build the period with the Cours as the type" do
        period.type.should == "Cours"
      end

      it "should build a period with the appropriate start time" do
        period.start_time.should == "16h00"
      end

      it "should build a period with the appropriate end time" do
        period.end_time.should == "20h00"
      end
    end
end