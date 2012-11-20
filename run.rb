#TEST RAPIDE DE PROOF OF CONCEPT

require_relative "app/ets_pdf_schedule_parser"
require_relative "app/conditional_combinator"
require_relative "app/models/course"
require_relative "app/models/group"
require_relative "app/models/period"

WANTED_COURSES = ["GPE450", "LOG550", "LOG619", "LOG640", "LOG670", "ING500", "MAT472", "GIA601"]
WEEKDAYS_FR = %w(lundi mardi mercredi jeudi vendredi samedi dimanche)
WEEKDAYS_EN = %w(monday tuesday wednesday thursday friday saturday sunday)
FR_TO_EN_WEEKDAYS = Hash[*7.times.collect {|nb| [WEEKDAYS_FR[nb][0..2], WEEKDAYS_EN[nb]] }.flatten]

def build_course(course_struct)
  groups = course_struct.groups.collect do |group_struct|
    periods = group_struct.periods.collect do |period_struct|
      Period::on(FR_TO_EN_WEEKDAYS[period_struct.weekday.downcase]).from(period_struct.start_time).to(period_struct.end_time)
    end
    Group.new(group_struct.nb)::with(*periods)
  end
  Course.new(course_struct.name).with(*groups)
end

courses = []
EtsPdfScheduleParser::extract_courses("spec/data/LOG-h13.txt").each do |course_struct|
  courses << build_course(course_struct) if WANTED_COURSES.include?(course_struct.name)
end

courses.delete_at(7)

schedules = ConditionalCombinator::find_combinations(courses, 4) do |courses_combinations, course|
  courses_combinations.index do |comparable_course|
    comparable_course.conflicts?(course)
  end.nil?
end

schedules.each do |schedule|
  puts "------------------"
  schedule.each do |course|
    puts course.name
  end
end