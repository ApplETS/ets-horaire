require_relative "app/utils/pdf_schedule_parser"
require_relative "app/builders/course_builder"
require_relative "app/utils/course_utils"
require_relative "app/schedule_finder"
require_relative "app/printers/list_schedule_printer"
require_relative "app/printers/calendar_schedule_printer"
require_relative "app/printers/html_schedule_printer"

WANTED_COURSES = ["GPE450", "LOG550", "LOG619", "LOG640", "LOG670", "ING500", "MAT472", "GIA601"]
BASE_DIR = File.dirname(__FILE__)
COURSES_PDF = File.join(BASE_DIR, "data/horaire_logiciel_h13.pdf")
TXT_CONVERSION = File.join(BASE_DIR, "data/horaire_logiciel_h13.txt")
LIST_OUTPUT = File.join(BASE_DIR, "data/list_schedule_output")
CALENDAR_OUTPUT = File.join(BASE_DIR, "data/calendar_schedule_output")
HTML_OUTPUT = File.join(BASE_DIR, "data/schedule_output.html")

def warn_user
  puts "Be sure that you have the 'pdftotext' library installed, to be able to convert the course pdf to text."
end

begin
  pdftotext_output = `pdftotext -enc UTF-8 -layout #{COURSES_PDF} #{TXT_CONVERSION}`
rescue Errno::ENOENT => e
  warn_user
else
  warn_user if !pdftotext_output.empty?

  courses_txt = File.open(TXT_CONVERSION, "r")

  courses_struct = PdfScheduleParser.extract_courses_from(courses_txt)
  courses_struct.select! { |course_struct| WANTED_COURSES.include? course_struct.name }
  courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
  CourseUtils.cleanup! courses

  schedules = ScheduleFinder.combinations_for(courses, 4)

  ListSchedulePrinter.output schedules, LIST_OUTPUT

  File.open(CALENDAR_OUTPUT, "w") do |f|
    schedules.each do |schedule|
      f.write "*******************************************************************************************\n"
      f.write "*******************************************************************************************\n\n"
      CalendarSchedulePrinter.print schedule, f
      f.write "\n"
    end
  end

  File.open(HTML_OUTPUT, "w") do |f|
    f.write "<!DOCTYPE html>"
    f.write "<html>"
    f.write "<head>"
    f.write "<title>Html Schedule Output</title>"
    f.write "<style type='text/css'>"
    f.write HtmlSchedulePrinter.css
    f.write "</style>"
    f.write "</head>"
    f.write "<body>"
    f.write HtmlSchedulePrinter.html(schedules)
    f.write "</body>"
    f.write "</html>"
  end

end
