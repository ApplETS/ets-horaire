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
require_relative 'app/views/landing_view'
require_relative 'app/views/input_view'
require_relative 'app/views/output_view'

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

LandingView.new.render

config_file_path = nil
AutoCompleteFolderContents.in_setup do
  file_exists = false

  while !file_exists
    InputView.new.render do
      config_file_path = AutoCompleteFolderContents.readline
      file_exists = !File.directory?(config_file_path) && File.exists?(config_file_path)

      set :config_file_path, config_file_path
      set :file_exists, file_exists
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

OutputView.new({
 output_types: settings.output_types.keys,
 possible_output_types: POSSIBLE_OUTPUT_TYPES,
 output_destinations: output_destinations
}).render