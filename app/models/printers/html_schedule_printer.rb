# -*- encoding : utf-8 -*-

require "haml"

class HtmlSchedulePrinter

  def self.output(schedules, output_folder)
    html = nil
    css = WebpageBuilder.css
    html_schedules = WebpageBuilder.html(schedules)
    open_template do |haml|
      html = Haml::Engine.new(haml.read).render(Object.new, content: html_schedules)
    end

    css_folder = File.join(output_folder, "css")

    Dir.mkdir(output_folder) unless File.directory? output_folder
    Dir.mkdir(css_folder) unless File.directory? css_folder
    FileUtils.cp File.join(File.dirname(__FILE__), "./html/ressources/normalize.css"), css_folder
    File.open(File.join(output_folder, "css/stylesheet.css"), "w") { |f| f.write css }
    File.open(File.join(output_folder, "index.html"), "w") { |f| f.write html }
  end

  private

  def self.open_template(&block)
    File.open(File.join(File.dirname(__FILE__), "./html/ressources/output_template.html.haml"), "r", &block)
  end

end
