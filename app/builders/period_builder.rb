require_relative "../models/period"

class PeriodBuilder

  WEEKDAYS_FR = %w(lundi mardi mercredi jeudi vendredi samedi dimanche)
  WEEKDAYS_EN = %w(monday tuesday wednesday thursday friday saturday sunday)
  WEEKDAYS_NB = 7
  FR_TO_EN_WEEKDAYS = Hash[*WEEKDAYS_NB.times.collect { |index| [WEEKDAYS_FR[index][0..2], WEEKDAYS_EN[index]] }.flatten]

  def self.build(period_struct)
    Period.on(en_weekday_from period_struct).from(period_struct.start_time).to(period_struct.end_time)
  end

  private

  def self.en_weekday_from(period_struct)
    FR_TO_EN_WEEKDAYS[period_struct.weekday.downcase]
  end

end