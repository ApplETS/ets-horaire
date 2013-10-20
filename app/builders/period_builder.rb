# -*- encoding : utf-8 -*-
require_relative "../models/period"
require_relative "../models/weekday"

class PeriodBuilder

  def self.build(period_struct)
    Period.on(en_weekday_from period_struct).of_type(filter_type_of period_struct).from(period_struct.start_time).to(period_struct.end_time)
  end

  private

  def self.en_weekday_from(period_struct)
    Weekday.short_fr(period_struct.weekday.downcase).en
  end

  def self.filter_type_of(period_struct)
    type = period_struct.type
    type == "C" ? "Cours" : type
  end

end
