require_relative "../../app/models/weekday"

EN_WEEKDAYS = %w(monday tuesday wednesday thursday friday saturday sunday)
FR_WEEKDAYS = %w(lundi mardi mercredi jeudi vendredi samedi dimanche)

describe Weekday do

  EN_WEEKDAYS.each_with_index do |en_weekday, index|
    short_en_weekday = en_weekday[0..2]
    fr_weekday = FR_WEEKDAYS[index]

    describe "when creating a weekday on #{en_weekday} in english" do
      let(:weekday) { Weekday.en en_weekday }

      it "should have its index in the week" do
        weekday.index.should == index
      end

      it "should have #{en_weekday} as the english name" do
        weekday.en.should == en_weekday
      end

      it "should have #{fr_weekday} as the french name" do
        weekday.fr.should == fr_weekday
      end
    end

    describe "when creating a short weekday on #{en_weekday} in english" do
      let(:weekday) { Weekday.short_en short_en_weekday }

      it "should have its index in the week" do
        weekday.index.should == index
      end

      it "should have #{en_weekday} as the english name" do
        weekday.en.should == en_weekday
      end

      it "should have #{fr_weekday} as the french name" do
        weekday.fr.should == fr_weekday
      end
    end
  end

  FR_WEEKDAYS.each_with_index do |fr_weekday, index|
    short_fr_weekday = fr_weekday[0..2]
    en_weekday = EN_WEEKDAYS[index]

    describe "when creating a weekday on #{en_weekday} in french" do
      let(:weekday) { Weekday.fr fr_weekday }

      it "should have its index in the week" do
        weekday.index.should == index
      end

      it "should have #{en_weekday} as the english name" do
        weekday.en.should == en_weekday
      end

      it "should have #{fr_weekday} as the french name" do
        weekday.fr.should == fr_weekday
      end
    end

    describe "when creating a short weekday on #{en_weekday} in french" do
      let(:weekday) { Weekday.short_fr short_fr_weekday }

      it "should have its index in the week" do
        weekday.index.should == index
      end

      it "should have #{en_weekday} as the english name" do
        weekday.en.should == en_weekday
      end

      it "should have #{fr_weekday} as the french name" do
        weekday.fr.should == fr_weekday
      end
    end
  end

end