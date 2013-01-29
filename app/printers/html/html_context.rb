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
    "period #{period.color} from-#{start_time_of period} duration-#{duration_of period}"
  end

  def format_time_of(period)
    "#{flat_time period.start_time} - #{flat_time period.end_time}"
  end

  def zerofill(hour)
    hour.to_s.rjust(2, "0")
  end

  def start_time_of(period)
    joined_flat_time period.start_time
  end

  def duration_of(period)
    joined_flat_time period.end_time - period.start_time
  end

  def joined_flat_time(time)
    "#{hour time}#{minutes time}"
  end

  def flat_time(time)
    "#{hour time}:#{minutes time}"
  end

  def hour(time)
    zerofill (time / 60).floor
  end

  def minutes(time)
    zerofill time % 60
  end

end