# -*- encoding : utf-8 -*-

require "erb"
require "compass"
require "haml"

class WebpageBuilder
  HOURS = (8..23)

  WeekdayStruct = Struct.new(:name, :periods)
  PeriodStruct = Struct.new(:css_class, :start_time, :end_time, :duration, :course, :type)

  def self.css
    stylesheet_context = StylesheetContext.new(weekdays_en, HOURS)
    open("stylesheet.css.sass.erb") do |erb|
      sass = ERB.new(erb.read).result(stylesheet_context.get_binding)
      Sass::Engine.new(sass, Compass.configuration.to_sass_engine_options).render
    end
  end

  def self.html(schedules)
    open("schedule.html.haml") do |haml|
      template = haml.read
      html = process(schedules).collect do |schedule|
        html_context = HtmlContext.new(weekdays_fr, HOURS, schedule)
        Haml::Engine.new(template).render(html_context)
      end
      html.join
    end
  end

  private

  def self.open(ressource_name, &block)
    File.open(File.join(File.dirname(__FILE__), "./ressources/#{ressource_name}"), "r", &block)
  end

  def self.weekdays_en
    Weekday::LANGUAGES[:EN].first(5)
  end

  def self.weekdays_fr
    Weekday::LANGUAGES[:FR].first(5).collect { |weekday| weekday.capitalize }
  end

  def self.process(schedules)
    html_schedules = []
    schedules.each do |schedule|
      weekdays = []
      schedule.each_with_index do |course_group, index|
        course_group.periods.each do |period|
          if weekdays.none? { |weekday| weekday.name == period.weekday.en }
            periods = []
            weekdays << WeekdayStruct.new(period.weekday.en, periods)
          else
            periods = (weekdays.find { |weekday| weekday.name == period.weekday.en }).periods
          end

          periods << PeriodStruct.new("period-#{index + 1}", period.start_time, period.end_time, period.duration, "#{course_group.course_name}-#{course_group.nb}", period.type)
        end
      end
      html_schedules << weekdays
    end
    html_schedules
  end

end
