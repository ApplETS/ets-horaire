# encoding: utf-8

require 'yaml'
require 'colorize'
require 'settingslogic'
require_relative 'app/utils/pdf_stream'
require_relative 'app/utils/stream_course_builder'
require_relative 'app/builders/course_builder'
require_relative 'app/utils/course_utils'
require_relative 'app/schedule_finder'
require_relative 'app/printers/list_schedule_printer'
require_relative 'app/printers/calendar_schedule_printer'
require_relative 'app/printers/html_schedule_printer'

BASE_DIR = File.dirname(__FILE__)

puts "*********************************".blue
puts "* Calculateur d'horaire à l'ÉTS *".blue
puts "*********************************".blue
puts ""

file_exists = false
while !file_exists
  puts "Veuillez rentrer le ficher de configuration:".light_blue
  config_file_path = File.join(BASE_DIR, "#{gets.chomp}.yml")

  file_exists = File.exists?(config_file_path)
  if file_exists
    puts "Utilisation du fichier: ".light_blue + config_file_path.yellow
  else
    puts "Fichier invalide: ".red + config_file_path.yellow
  end
end

class String
  def path
    File.join(File.dirname(__FILE__), self)
  end
end

Settings = Class.new(Settingslogic) do
  source config_file_path
end

OUTPUT_DIR = Settings.output_folder.path

LIST_OUTPUT_FILE = File.join(OUTPUT_DIR, Settings.output_types.list.output_file)
CALENDAR_OUTPUT_FILE = File.join(OUTPUT_DIR, Settings.output_types.calendar.output_file)
HTML_OUTPUT_FOLDER = File.join(OUTPUT_DIR, Settings.output_types.html.output_folder)

# -------------
# Begin program
# -------------
FileUtils.rm_rf(OUTPUT_DIR) if File.directory?(OUTPUT_DIR)
Dir.mkdir(OUTPUT_DIR)

courses_stream = PdfStream.from_file(Settings.input.path)

courses_struct = StreamCourseBuilder.build_courses_from(courses_stream)
courses_struct.select! { |course_struct| Settings.wanted_courses.include? course_struct.name }
courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
CourseUtils.cleanup! courses

schedules = ScheduleFinder.combinations_for(courses, Settings.filters.courses_per_schedule)

ListSchedulePrinter.output schedules, LIST_OUTPUT_FILE
CalendarSchedulePrinter.output schedules, CALENDAR_OUTPUT_FILE
HtmlSchedulePrinter.output schedules, HTML_OUTPUT_FOLDER