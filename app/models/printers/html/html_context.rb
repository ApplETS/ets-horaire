# -*- encoding : utf-8 -*-

class HtmlContext

  def initialize(weekdays, hours, schedule)
    @weekdays = weekdays
    @hours = hours
    @schedule = schedule
  end

  private

  def hour_string_with(hour)
    "#{zerofill hour}:00"
  end

  def last?(hour)
    @hours.last == hour
  end

  def weekday_classes_for(weekday)
    "weekday #{weekday.name}"
  end

  def period_classes_for(period)
    "period #{period.css_class} from-#{flat_time period.start_time} duration-#{duration_of period}"
  end

  def format_time_of(period)
    "#{period.start_time.to_s} - #{period.end_time.to_s}"
  end

  def duration_of(period)
    "#{zerofill hour(period)}#{zerofill minutes(period)}"
  end

  def flat_time(time)
    "#{zerofill time.hour}#{zerofill time.minutes}"
  end

  def hour(period)
    (period.duration / 60).floor
  end

  def minutes(period)
    period.duration % 60
  end

  def zerofill(time)
    time.to_s.rjust(2, "0")
  end

end
