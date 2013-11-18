# -*- encoding : utf-8 -*-

class Period
  attr_reader :weekday, :type, :start_time, :end_time

  def initialize(weekday, type, start_time, end_time)
    @weekday = weekday
    @type = type
    @start_time = start_time
    @end_time = end_time
  end

  def duration
    @end_time.to_weekday_i - @start_time.to_weekday_i
  end

  def conflicts?(period)
    !(before?(period) || after?(period))
  end

  private

  def before?(period)
    period.start_time.to_week_i < @start_time.to_week_i &&
    period.end_time.to_week_i < @start_time.to_week_i
  end

  def after?(period)
    period.start_time.to_week_i > @end_time.to_week_i &&
    period.end_time.to_week_i > @end_time.to_week_i
  end

end
