require_relative "app/utils/pdf_schedule_parser"
require_relative "app/builders/course_builder"
require_relative "app/utils/course_utils"
require_relative "app/schedule_finder"
require_relative "app/printers/list_schedule_printer"
require_relative "app/printers/calendar_schedule_printer"
require_relative "app/printers/html_schedule_printer"

WANTED_COURSES = %w(GPE450 LOG550 LOG619 LOG640 LOG670 ING500 MAT472 GIA601)

BASE_DIR = File.join(File.dirname(__FILE__), "data")
INPUT_DIR = File.join(BASE_DIR, "input")
OUTPUT_DIR = File.join(BASE_DIR, "output")

COURSES_PDF = File.join(INPUT_DIR, "horaire_logiciel_h13.pdf")
TXT_CONVERSION = File.join(INPUT_DIR, "horaire_logiciel_h13.txt")

LIST_OUTPUT_FILE = File.join(OUTPUT_DIR, "list_schedule")
CALENDAR_OUTPUT_FILE = File.join(OUTPUT_DIR, "calendar_schedule")
HTML_OUTPUT_FOLDER = File.join(OUTPUT_DIR, "html_schedule")

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

  ListSchedulePrinter.output schedules, LIST_OUTPUT_FILE

  File.open(CALENDAR_OUTPUT_FILE, "w") do |f|
    schedules.each do |schedule|
      f.write "*******************************************************************************************\n"
      f.write "*******************************************************************************************\n\n"
      CalendarSchedulePrinter.print schedule, f
      f.write "\n"
    end
  end

  HtmlSchedulePrinter.output schedules, HTML_OUTPUT_FOLDER

end
