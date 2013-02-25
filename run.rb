require_relative "app/utils/convert"
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

COURSES_PDF = File.join(INPUT_DIR, "horaire_logiciel_h13")

LIST_OUTPUT_FILE = File.join(OUTPUT_DIR, "list_schedule")
CALENDAR_OUTPUT_FILE = File.join(OUTPUT_DIR, "calendar_schedule")
HTML_OUTPUT_FOLDER = File.join(OUTPUT_DIR, "html_schedule")

# Begin program

courses_txt_stream = Convert.pdf_to_text(COURSES_PDF)

courses_struct = PdfScheduleParser.extract_courses_from(courses_txt_stream)
courses_struct.select! { |course_struct| WANTED_COURSES.include? course_struct.name }
courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
CourseUtils.cleanup! courses

schedules = ScheduleFinder.combinations_for(courses, 4)

ListSchedulePrinter.output schedules, LIST_OUTPUT_FILE
CalendarSchedulePrinter.output schedules, CALENDAR_OUTPUT_FILE
HtmlSchedulePrinter.output schedules, HTML_OUTPUT_FOLDER