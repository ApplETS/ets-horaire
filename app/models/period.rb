require_relative "weekday"

class Period
  
  MINUTES_PER_HOUR = 60
  MINUTES_PER_DAY = 24 * MINUTES_PER_HOUR

  attr_reader :type, :start_time, :end_time

  def initialize(weekday, type)
    @weekday = Weekday.en(weekday)
    @type = type
    @weekday_minutes = @weekday.index * MINUTES_PER_DAY
    @from_minutes = 0
    @to_minutes = 0
  end

  def self.on(weekday, type)
    Period.new(weekday, type)
  end

  def from(time)
    @start_time = time
    @from_minutes = plain_time_to_int(time)
    self
  end

  def to(time)
    @end_time = time
    @to_minutes = plain_time_to_int(time)
    self
  end

  def weekday
    @weekday.en
  end

  def start_time_int
    @weekday_minutes + @from_minutes
  end

  def end_time_int
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
    period.start_time_int < start_time_int && period.start_time_int < end_time_int && period.end_time_int < start_time_int && period.end_time_int < end_time_int
  end

  def after?(period)
    period.start_time_int > start_time_int && period.start_time_int > end_time_int && period.end_time_int > start_time_int && period.end_time_int > end_time_int
  end

end