require_relative "app/utils/pdf_schedule_parser"
require_relative "app/builders/course_builder"
require_relative "app/utils/course_utils"
require_relative "app/schedule_finder"
require_relative "app/utils/schedule_list_printer"
require_relative "app/utils/schedule_printer"

WANTED_COURSES = ["GPE450", "LOG550", "LOG619", "LOG640", "LOG670", "ING500", "MAT472", "GIA601"]

courses = PdfScheduleParser::extract_courses("data/LOG-h13.txt").collect do |course_struct|
  CourseBuilder.build(course_struct) if WANTED_COURSES.include?(course_struct.name)
end
courses.delete_if { |course| course.nil? }
courses = CourseUtils.cleanup(courses)

schedules = ScheduleFinder.combinations_for(courses, 4)

ScheduleListPrinter.output schedules, "data/schedule_list_output"

File.open("data/schedule_output", "w") do |file|
  schedules.each do |schedule|
    file.write "*******************************************************************************************\n"
    file.write "*******************************************************************************************\n\n"
    SchedulePrinter.print schedule, file
    file.write "\n"
  end
end