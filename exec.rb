# encoding: utf-8

require 'yaml'
require 'colorize'
require 'settingslogic'

require_relative 'app/cli/auto_complete_folder_contents'
require_relative 'app/utils/pdf_stream'
require_relative 'app/utils/stream_course_builder'
require_relative 'app/builders/course_builder'
require_relative 'app/utils/course_utils'
require_relative 'app/schedule_finder'
require_relative 'app/printers/list_schedule_printer'
require_relative 'app/printers/calendar_schedule_printer'
require_relative 'app/printers/html_schedule_printer'

puts "* * * * * * * * * * * * * * * * * * *".blue
puts "*                                   *".blue
puts "*   Calculateur d'horaire à l'ÉTS   *".blue
puts "*                                   *".blue
puts "* * * * * * * * * * * * * * * * * * *".blue
puts ""

def input_view
  puts "Veuillez rentrer le ficher de configuration:".light_blue

  instance_variables = yield

  if instance_variables[:file_exists]
    puts ""
    puts "Utilisation du fichier: ".light_blue + instance_variables[:config_file_path].yellow
    puts ""
  else
    puts "Fichier invalide: ".red + instance_variables[:config_file_path].yellow
  end
end

config_file_path = nil
AutoCompleteFolderContents.in_setup do
  file_exists = false

  while !file_exists
    input_view do
      config_file_path = readline
      file_exists = !File.directory?(config_file_path) && File.exists?(config_file_path)

      {config_file_path: config_file_path, file_exists: file_exists}
    end
  end
end

settings = Class.new(Settingslogic) { source config_file_path }

# -------------
# Begin program
# -------------
FileUtils.rm_rf(settings.output_folder) if File.directory?(settings.output_folder)
Dir.mkdir(settings.output_folder)

courses_stream = PdfStream.from_file(settings.input)

courses_struct = StreamCourseBuilder.build_courses_from(courses_stream)
courses_struct.select! { |course_struct| settings.wanted_courses.include? course_struct.name }
courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
CourseUtils.cleanup! courses

schedules = ScheduleFinder.combinations_for(courses, settings.filters.courses_per_schedule)

POSSIBLE_OUTPUT_TYPES = {
  'list' => {
    class: ListSchedulePrinter,
    output_destination_key: 'output_file'
  },
  'calendar' => {
    class: CalendarSchedulePrinter,
    output_destination_key: 'output_file'
  },
  'html' => {
    class: HtmlSchedulePrinter,
    output_destination_key: 'output_folder'
  },
}

# Controller
output_destinations = {}
settings.output_types.each_pair.collect do |output_type, output_settings|
  parameters = POSSIBLE_OUTPUT_TYPES[output_type]

  unless parameters.nil?
    output_destination_key = parameters[:output_destination_key]
    output_destination = File.join(settings.output_folder, output_settings[output_destination_key])
    output_destinations[output_type] = output_destination
  end
end

settings.output_types.keys.each do |output_type|
  parameters = POSSIBLE_OUTPUT_TYPES[output_type]
  output_destination = output_destinations[output_type]
  parameters[:class].send(:output, schedules, output_destination) unless parameters.nil?
end

# View
settings.output_types.keys.each do |output_type|
  if POSSIBLE_OUTPUT_TYPES.include? output_type
    output_destination = output_destinations[output_type]
    puts "(#{output_type}) Écriture des résultats dans: ".green + output_destination.yellow
  else
    puts "Le type '#{output_type}' n'existe pas. Ignorant le type.".red
  end
end