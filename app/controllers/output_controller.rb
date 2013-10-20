# -*- encoding : utf-8 -*-

require 'fileutils'
require 'settingslogic'

class OutputController < Controller
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
    }
  }

  def index
    config_file_path = params[:config_file_path]
    @settings = Class.new(Settingslogic) { source config_file_path }

    @config_file_path = config_file_path
    @output_types = @settings.output_types.keys
    @possible_output_types = POSSIBLE_OUTPUT_TYPES

    create_output_folder
    courses_stream = PdfStream.from_file(@settings.input)
    courses = build_courses_from(courses_stream)
    schedules = ScheduleFinder.combinations_for(courses, @settings.filters.courses_per_schedule)

    @output_destinations = {}
    create_output_destinations

    output schedules
  end

  private

  def create_output_folder
    FileUtils.rm_rf(@settings.output_folder) if File.directory?(@settings.output_folder)
    Dir.mkdir(@settings.output_folder)
  end

  def build_courses_from(courses_stream)
    courses_struct = StreamCourseBuilder.build_courses_from(courses_stream)
    courses_struct.select! { |course_struct| @settings.wanted_courses.include? course_struct.name }
    courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
    CourseUtils.cleanup! courses
    courses
  end

  def create_output_destinations
    @settings.output_types.each_pair.collect do |output_type, output_settings|
      parameters = POSSIBLE_OUTPUT_TYPES[output_type]

      unless parameters.nil?
        output_destination_key = parameters[:output_destination_key]
        output_destination = File.join(@settings.output_folder, output_settings[output_destination_key])
        @output_destinations[output_type] = output_destination
      end
    end
  end

  def output(schedules)
    @output_types.each do |output_type|
      parameters = POSSIBLE_OUTPUT_TYPES[output_type]
      output_destination = @output_destinations[output_type]
      parameters[:class].send(:output, schedules, output_destination) unless parameters.nil?
    end
  end
end
