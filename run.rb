require_relative "app/utils/pdf_schedule_parser"
require_relative "app/schedule_finder"
require_relative "app/builders/course_builder"
require_relative "app/utils/course_utils"

WANTED_COURSES = ["GPE450", "LOG550", "LOG619", "LOG640", "LOG670", "ING500", "MAT472", "GIA601"]

courses = PdfScheduleParser::extract_courses("spec/data/LOG-h13.txt").collect do |course_struct|
  CourseBuilder.build(course_struct) if WANTED_COURSES.include?(course_struct.name)
end
courses.delete_if { |course| course.nil? }
courses = CourseUtils.cleanup(courses)

schedules = ScheduleFinder.combinations_for(courses, 4)

schedules.each do |schedule|
   puts "------------------"
   schedule.each do |group|
     puts "#{group.course_name} - #{group.nb}"
   end
end