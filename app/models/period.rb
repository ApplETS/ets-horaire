class Period
  
  WEEKDAYS_INT = Hash[*%w(monday tuesday wednesday thursday friday saturday sunday).each_with_index.collect { |weekday, index| [weekday, index] }.flatten]
  
  MINUTES_PER_DAY = 1440
  MINUTES_PER_HOUR = 60

  def initialize(weekday)
    @weekday_minutes = WEEKDAYS_INT[weekday.downcase] * MINUTES_PER_DAY
    @from_minutes = 0
    @to_minutes = 0
  end

  def self.on(weekday)
    Period.new(weekday)
  end

  def from(time)
    @from_minutes = plain_time_to_int(time)
    self
  end

  def to(time)
    @to_minutes = plain_time_to_int(time)
    self
  end

  def from_time
    @weekday_minutes + @from_minutes
  end

  def to_time
    @weekday_minutes + @to_minutes
  end

  def conflicts?(period)
    !(before?(period) || after?(period))
  end

  private

  def plain_time_to_int(plain_time)
    hours, minutes = plain_time.split("h")
    hours.to_i * MINUTES_PER_HOUR + minutes.to_i
  end

  def before?(period)
    period.from_time < from_time && period.from_time < to_time && period.to_time < from_time && period.to_time < to_time
  end

  def after?(period)
    period.from_time > from_time && period.from_time > to_time && period.to_time > from_time && period.to_time > to_time
  end

end