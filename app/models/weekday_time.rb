# -*- encoding : utf-8 -*-

class WeekdayTime

  MINUTES_PER_HOUR = 60
  MINUTES_PER_DAY = 24 * MINUTES_PER_HOUR

  attr_reader :weekday, :hour, :minutes

  def initialize(weekday, hour, minutes)
    @weekday = weekday
    @hour = hour
    @minutes = minutes
    @week_time_int = @weekday.index * MINUTES_PER_DAY
    @weekday_time_int = hour * MINUTES_PER_HOUR + minutes
  end

  def to_weekday_i
    @weekday_time_int
  end

  def to_week_i
    @week_time_int + @weekday_time_int
  end

  def to_s
    "#{zerofill @hour}:#{zerofill @minutes}"
  end

  private

  def zerofill(time)
    time.to_s.rjust(2, "0")
  end

end
