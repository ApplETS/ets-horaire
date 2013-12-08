# -*- encoding : utf-8 -*-

class ListSchedulePrinter

  def self.output(schedules, output_filename)
    File.open(output_filename, 'w') do |file|
      schedules.each do |groups|
        file.write 58.times.collect { "*" }.join + "\n"
        file.write 58.times.collect { "*" }.join + "\n"
        file.write "\n"

        groups.each do |group|
          file.write "#{group.course_name}\n"
          file.write 58.times.collect { "-" }.join + "\n"
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
    "#{spacify(period.type)}#{spacify(weekday period)}#{period.start_time.to_s} - #{period.end_time.to_s}\n"
  end

  def self.spacify(text = "")
    spaces = (15 - text.length).times.collect { " " }.join
    "#{text}#{spaces}"
  end

  def self.weekday(period)
    period.weekday.fr.capitalize
  end

end
