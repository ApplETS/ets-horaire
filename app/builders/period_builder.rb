require_relative "../models/period"
require_relative "../models/weekday"

class PeriodBuilder

  def self.build(period_struct)
    Period.on(en_weekday_from(period_struct), period_struct.type).from(period_struct.start_time).to(period_struct.end_time)
  end

  private

  def self.en_weekday_from(period_struct)
    Weekday.short_fr(period_struct.weekday.downcase).en
  end

end