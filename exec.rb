# -*- encoding : utf-8 -*-

require 'rubygems'
require 'pathname'

AUTOLOAD_FILE_PATTERN = 'app/**/*.rb'

def setup_autoload_for(file_pattern)
  $:.unshift File.dirname(__FILE__)
  Dir[file_pattern].each { |filename| autoload to_camel_case(filename), filename }
end

def to_camel_case(filename)
  basename = Pathname.new(filename).basename.to_s
  basename_without_ruby_extension = basename[0..-4]
  camel_case_parts = basename_without_ruby_extension.split('_').collect { |part| part[0].upcase + part[1..-1] }
  camel_case_parts.join
end

setup_autoload_for AUTOLOAD_FILE_PATTERN
Application.new.run :landing, :index