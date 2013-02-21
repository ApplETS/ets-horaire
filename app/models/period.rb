require_relative "weekday_time"
require_relative "weekday"

class Period
  
  MINUTES_PER_HOUR = 60
  MINUTES_PER_DAY = 24 * MINUTES_PER_HOUR

  attr_reader :weekday, :type, :start_time, :end_time

  def initialize(weekday)
    @weekday = Weekday.en(weekday)
    @weekday_minutes = @weekday.index * MINUTES_PER_DAY
  end

  def self.on(weekday)
    Period.new(weekday)
  end

  def from(time)
    hour, minutes = time_split_int(time)
    @start_time = WeekdayTime.on(@weekday).at(hour, minutes)
    self
  end

  def to(time)
    hour, minutes = time_split_int(time)
    @end_time = WeekdayTime.on(@weekday).at(hour, minutes)
    raise "the 'to' method must be called after the 'from' method and be bigger than the latter." if invalid_end_time?
    self
  end

  def of_type(type)
    @type = type
    self
  end

  def duration
    return 0 if @start_time.nil? || @end_time.nil?
    @end_time.to_weekday_i - @start_time.to_weekday_i
  end

  def conflicts?(period)
    !(before?(period) || after?(period))
  end

  private

  def invalid_end_time?
    @start_time.to_week_i > @end_time.to_week_i
  end

  def time_split_int(plain_time)
    hour, minutes = plain_time.split(":")
    [hour.to_i, minutes.to_i]
  end

  def before?(period)
    period.start_time.to_week_i < @start_time.to_week_i &&
    period.end_time.to_week_i < @start_time.to_week_i
  end

  def after?(period)
    period.start_time.to_week_i > @end_time.to_week_i &&
    period.end_time.to_week_i > @end_time.to_week_i
  end

end