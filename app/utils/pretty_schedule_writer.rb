class PrettyScheduleWriter

  def self.output(schedules, output_filename)
    File.open(output_filename, 'w') do |file|
      schedules.each do |groups|
        file.write 43.times.collect { "*" }.join + "\n"
        file.write 43.times.collect { "*" }.join + "\n"
        file.write "\n"

        groups.each do |group|
          file.write "#{group.course_name}\n"
          file.write 43.times.collect { "-" }.join + "\n"
          group_zerofilled = group.nb.to_s.rjust(2, "0")
          file.write "#{spacify(group_zerofilled)}#{output_period(group.periods[0])}"
          group.periods[1..-1].each do |period|
            file.write "#{spacify}#{output_period(period)}"
          end
          file.write "\n"
        end
      end
    end
  end

  private

  def self.output_period(period)
    "#{spacify(period.type)}#{spacify(period.weekday)}#{period.start_time} - #{period.end_time}\n"
  end

  def self.spacify(text = "")
    spaces = (10 - text.length).times.collect { " " }.join
    "#{text}#{spaces}"
  end

end