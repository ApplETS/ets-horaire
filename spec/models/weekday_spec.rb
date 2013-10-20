# -*- encoding : utf-8 -*-
require 'spec_helper'

EN_WEEKDAYS = %w(monday tuesday wednesday thursday friday saturday sunday) unless defined?(EN_WEEKDAYS)
FR_WEEKDAYS = %w(lundi mardi mercredi jeudi vendredi samedi dimanche) unless defined?(FR_WEEKDAYS)

describe Weekday do

  describe "When creating an invalid weekday" do
    let(:en_weekday) { Weekday.en "en not valid" }
    let(:fr_weekday) { Weekday.fr "fr not valid" }
    let(:short_en_weekday) { Weekday.short_en "short_en not valid" }
    let(:short_fr_weekday) { Weekday.short_fr "short_fr not valid" }

    specify { expect { en_weekday }.to raise_error "'en not valid' is not a valid weekday." }
    specify { expect { fr_weekday }.to raise_error "'fr not valid' is not a valid weekday." }
    specify { expect { short_en_weekday }.to raise_error "'short_en not valid' is not a valid weekday." }
    specify { expect { short_fr_weekday }.to raise_error "'short_fr not valid' is not a valid weekday." }
  end

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
