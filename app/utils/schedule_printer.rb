class SchedulePrinter

  COLUMN_WIDTH = 16
  NB_COLUMNS = 5
  FULL_COLUMN_SPACE = COLUMN_WIDTH.times.collect { " " }.join
  FULL_SCHEDULE_LINE = (COLUMN_WIDTH * NB_COLUMNS + NB_COLUMNS + 1).times.collect { "-" }.join
  MINUTES_PER_HOUR = 60
  MONDAY = 0
  TUESDAY = 1440
  WEDNESDAY = 2880
  THURSDAY = 4320
  FRIDAY = 5760

  def self.print(schedule, stream)
    stream.write "     #{FULL_SCHEDULE_LINE}\n"
    stream.write "     |#{align_left "Lundi"}|#{align_left "Mardi"}|#{align_left "Mercredi"}|#{align_left "Jeudi"}|#{align_left "Vendredi"}|\n"
    stream.write "     #{FULL_SCHEDULE_LINE}\n"
    (8..23).each do |hour|
      stream.write print_line(hour, schedule)
    end
    stream.write "     #{FULL_SCHEDULE_LINE}\n"
  end

  private

  def self.print_line(hour, schedule)
    hour_zerofilled = hour.to_s.rjust(2, "0")
    "#{hour_zerofilled}:00|#{print_column MONDAY, hour, schedule}|#{print_column TUESDAY, hour, schedule}|#{print_column WEDNESDAY, hour, schedule}|#{print_column THURSDAY, hour, schedule}|#{print_column FRIDAY, hour, schedule}|\n"
  end

  def self.print_column(weekday, hour, schedule)
    column = FULL_COLUMN_SPACE
    start_line_period = nil
    description = nil
    end_line_period = nil

    schedule.each do |group|
      group.periods.each do |period|
        start_line_period = period if start_line?(weekday, hour, period)
        description = print_description_line(group, period) if description_line?(weekday, hour, period)
        end_line_period = period if end_line?(weekday, hour, period)
      end
    end

    if description.nil?
      column = print_start_line(start_line_period) if !start_line_period.nil?
      column = print_end_line(end_line_period) if !end_line_period.nil?
      column = print_full_line(start_line_period, end_line_period) if !start_line_period.nil? && !end_line_period.nil?
    else
      column = description
    end

    column
  end

  def self.print_start_line(period)
    align_left zerofill_time(period.start_time_int), "-"
  end

  def self.start_line?(weekday, hour, period)
    schedule_start_time = period.start_time_int - weekday - hour * MINUTES_PER_HOUR
    schedule_start_time >= 0 && schedule_start_time < 60
  end

  def self.print_description_line(group, period)
    group_nb = group.nb.to_s.rjust(2, "0")
    full_course_denomination = "#{group.course_name}-#{group_nb}"
    short_course_type = shortify(period.type)
    justify full_course_denomination, short_course_type
  end

  def self.shortify(text)
    text.split(/([-\/ ])/).collect { |word| word[0].upcase }.join
  end

  def self.zerofill_time(time)
    minutes = time % MINUTES_PER_HOUR
    minutes.to_s.rjust(2, "0")
  end

  def self.description_line?(weekday, hour, period)
    schedule_start_time = period.start_time_int - weekday - hour * MINUTES_PER_HOUR
    schedule_start_time >= -60 && schedule_start_time < 0
  end

  def self.print_end_line(period)
    align_right zerofill_time(period.end_time_int), "-"
  end

  def self.end_line?(weekday, hour, period)
    schedule_end_time = period.end_time_int - weekday - hour * MINUTES_PER_HOUR
    schedule_end_time >= 0 && schedule_end_time < 60
  end

  def self.print_full_line(start_line_period, end_line_period)
    start_time = start_line_period.start_time_int % 60
    start_time_zerofilled = start_time.to_s.rjust(2, "0")
    end_time = end_line_period.end_time_int % 60
    end_time_zerofilled = end_time.to_s.rjust(2, "0")
    justify start_time_zerofilled, end_time_zerofilled, "-"
  end

  def self.print_filling_for(text, filler)
    (COLUMN_WIDTH - text.length).times.collect { filler }.join
  end

  def self.align_left(text, filler = " ")
    "#{text}#{print_filling_for text, filler}"
  end

  def self.align_right(text, filler = " ")
    "#{print_filling_for text, filler}#{text}"
  end

  def self.justify(left_text, right_text, filler = " ")
    spaces_nb = COLUMN_WIDTH - left_text.length - right_text.length
    spaces = spaces_nb.times.collect { filler }.join
    "#{left_text}#{spaces}#{right_text}"
  end

end