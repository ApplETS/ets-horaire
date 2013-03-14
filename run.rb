require_relative "app/utils/convert"
require_relative "app/utils/pdf_schedule_parser"
require_relative "app/builders/course_builder"
require_relative "app/utils/course_utils"
require_relative "app/schedule_finder"
require_relative "app/printers/list_schedule_printer"
require_relative "app/printers/calendar_schedule_printer"
require_relative "app/printers/html_schedule_printer"

WANTED_COURSES = %w(LOG515 LOG530 LOG540 LOG670 LOG710 LOG720 LOG735 GTI745 GTI770 GTI785 PHY335)
# LOG515 = Maintenant!
# LOG540 = A13
# LOG720 = A13 (MAIS JOUR!)
# LOG735 = Maintenant!

NB_COURSES = 4

BASE_DIR = File.join(File.dirname(__FILE__), "data")
INPUT_DIR = File.join(BASE_DIR, "input")
OUTPUT_DIR = File.join(BASE_DIR, "output-e13-#{NB_COURSES}")

COURSES_PDF = File.join(INPUT_DIR, "horaire_logiciel_e13")

LIST_OUTPUT_FILE = File.join(OUTPUT_DIR, "list_schedule")
CALENDAR_OUTPUT_FILE = File.join(OUTPUT_DIR, "calendar_schedule")
HTML_OUTPUT_FOLDER = File.join(OUTPUT_DIR, "html_schedule")

# Begin program
FileUtils.rm_rf(OUTPUT_DIR) if File.directory?(OUTPUT_DIR)
Dir.mkdir(OUTPUT_DIR)

courses_txt_stream = Convert.pdf_to_text(COURSES_PDF)

courses_struct = PdfScheduleParser.extract_courses_from(courses_txt_stream)
courses_struct.select! { |course_struct| WANTED_COURSES.include? course_struct.name }
courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
CourseUtils.cleanup! courses

schedules = ScheduleFinder.combinations_for(courses, NB_COURSES)

ListSchedulePrinter.output schedules, LIST_OUTPUT_FILE
CalendarSchedulePrinter.output schedules, CALENDAR_OUTPUT_FILE
HtmlSchedulePrinter.output schedules, HTML_OUTPUT_FOLDER