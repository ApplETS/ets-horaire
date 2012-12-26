class PrettyScheduleWriter

  def self.convert(input_filename, output_filename)
    File.open(output_filename, 'w') do |file|
      EtsPdfScheduleParser::extract_courses(input_filename).each do |course|
        file.write "#{course.name}\n"
        file.write 43.times.collect { "-" }.join + "\n"
        course.groups.each do |group|
          group_zerofilled = group.nb.to_s.rjust(2, "0")
          file.write "#{spacify(group_zerofilled)}#{output_period(group.periods[0])}"
          group.periods[1..-1].each do |period|
            file.write "#{spacify}#{output_period(period)}"
          end
          file.write "\n"
        end
        file.write "\n"
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