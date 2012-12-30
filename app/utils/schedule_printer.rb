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
    stream.write "     #{FULL_SCHEDULE_LINE}"
    stream.write "     |#{align_left "Lundi"}|#{align_left "Mardi"}|#{align_left "Mercredi"}|#{align_left "Jeudi"}|#{align_left "Vendredi"}|"
    stream.write "     #{FULL_SCHEDULE_LINE}"
    (8..23).each do |hour|
      stream.write print_line(hour, schedule)
    end
    stream.write "     #{FULL_SCHEDULE_LINE}"
  end

  private

  def self.print_line(hour, schedule)
    hour_zerofilled = hour.to_s.rjust(2, "0")
    "#{hour_zerofilled}:00|#{print_column MONDAY, hour, schedule}|#{print_column TUESDAY, hour, schedule}|#{print_column WEDNESDAY, hour, schedule}|#{print_column THURSDAY, hour, schedule}|#{print_column FRIDAY, hour, schedule}|"
  end

  def self.print_column(weekday, hour, schedule)
    column = FULL_COLUMN_SPACE
    schedule.each do |group|
      group.periods.each do |period|
        column = print_start_line(period) if start_line?(weekday, hour, period)
        column = print_description_line(group, period) if description_line?(weekday, hour, period)
        column = print_end_line(period) if end_line?(weekday, hour, period)
      end
    end
    column
  end

  def self.print_start_line(period)
    start_minutes = period.start_time_int % MINUTES_PER_HOUR
    start_minutes_zerofilled = start_minutes.to_s.rjust(2, "0")
    "#{start_minutes_zerofilled}--------------"
  end

  def self.start_line?(weekday, hour, period)
    schedule_start_time = weekday + hour * MINUTES_PER_HOUR - period.start_time_int
    schedule_start_time >= 0 && schedule_start_time < 60
  end

  def self.print_description_line(group, period)
    group_nb_zerofilled = group.nb.to_s.rjust(2, "0")
    full_course_denomination = "#{group.course_name}-#{group_nb_zerofilled}"
    short_course_type = shortify(period.type)
    spaces_nb = COLUMN_WIDTH - full_course_denomination.length - short_course_type.length
    spaces = spaces_nb.times.collect { " " }.join
    "#{full_course_denomination}#{spaces}#{short_course_type}"
  end

  def self.shortify(text)
    text.split(/([-\/ ])/).collect { |word| word[0].upcase }.join
  end

  def self.description_line?(weekday, hour, period)
    schedule_start_time = weekday + hour * MINUTES_PER_HOUR - period.start_time_int
    schedule_start_time >= 60 && schedule_start_time < 120
  end

  def self.print_end_line(period)
    end_minutes = period.end_time_int % MINUTES_PER_HOUR
    end_minutes_zerofilled = end_minutes.to_s.rjust(2, "0")
    "--------------#{end_minutes_zerofilled}"
  end

  def self.end_line?(weekday, hour, period)
    schedule_end_time = weekday + hour * MINUTES_PER_HOUR - period.end_time_int
    schedule_end_time >= 0 && schedule_end_time < 60
  end

  def self.print_filling_from(text, filler)
    (COLUMN_WIDTH - text.length).times.collect { filler }.join
  end

  def self.align_left(text, filler = " ")
    "#{text}#{print_filling_from text, filler}"
  end

  def self.align_right(text, filler = " ")
    "#{print_filling_from text, filler}#{text}"
  end

end