module ScheduleHelper

  HOURS = (8..23)
  WEEKDAYS = %w(Lundi Mardi Mercredi Jeudi Vendredi)

  def foreach_weekday
    WEEKDAYS.each { |weekday| yield weekday }
  end

  def foreach_hour
    HOURS.each { |hour| yield hour }
  end

  def hour_string_with(hour)
    "#{zerofill hour}:00"
  end

  def halfhour_string_with(hour)
    "#{zerofill hour}:30"
  end

  def last?(hour)
    HOURS.last == hour
  end

  def weekday_classes(weekday)
    "weekday #{weekday.name}"
  end

  def period_classes(period)
    "period #{period.color} from-#{start_time_of period} duration-#{duration_of period}"
  end

  def format_time_of(period)
    "#{flat_time period.start_time} - #{flat_time period.end_time}"
  end

  private

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