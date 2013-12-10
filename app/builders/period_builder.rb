# -*- encoding : utf-8 -*-

class PeriodBuilder
  class << self
    def build(period_struct)
      weekday = weekday_using(period_struct)
      type = filter_type_of(period_struct)
      start_time = convert_to_weekday_time_using(weekday, period_struct.start_time)
      end_time = convert_to_weekday_time_using(weekday, period_struct.end_time)

      raise "The start time must be smaller than the end time." if invalid?(start_time, end_time)

      Period.new(weekday, type, start_time, end_time)
    end

    private

    def weekday_using(period_struct)
      Weekday.short_fr(period_struct.weekday.downcase)
    end

    def filter_type_of(period_struct)
      type = period_struct.type
      type == "C" ? "Cours" : type
    end

    def convert_to_weekday_time_using(weekday, plain_time)
      hour, minutes = time_split_int(plain_time)
      @start_time = WeekdayTime.new(weekday, hour, minutes)
    end

    def time_split_int(plain_time)
      hour, minutes = plain_time.split(":")
      [hour.to_i, minutes.to_i]
    end

    def invalid?(start_time, end_time)
      start_time.to_week_i > end_time.to_week_i
    end
  end
end
