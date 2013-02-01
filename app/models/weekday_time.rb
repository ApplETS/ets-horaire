class WeekdayTime

  MINUTES_PER_HOUR = 60
  MINUTES_PER_DAY = 24 * MINUTES_PER_HOUR

  attr_reader :weekday

  def initialize(weekday)
    @weekday = weekday
    @week_time_int = @weekday.index * MINUTES_PER_DAY
    @weekday_time_int = 0
    @start_time = "00:00"
  end

  def self.on(weekday)
    WeekdayTime.new(weekday)
  end

  def at(time)
    @start_time = time
    @weekday_time_int = plain_time_to_int(time)
    self
  end

  def to_s
    @start_time
  end

  def to_weekday_i
    @weekday_time_int
  end

  def to_week_i
    @week_time_int + @weekday_time_int
  end

  private

  def plain_time_to_int(plain_time)
    hours, minutes = plain_time.split(":")
    hours.to_i * MINUTES_PER_HOUR + minutes.to_i
  end

end