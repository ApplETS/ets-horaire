# -*- encoding : utf-8 -*-

require 'rubygems'
require 'pathname'
require_relative 'app/autoload'

AUTOLOAD_FILE_PATTERN = 'app/**/*.rb'

setup_autoload_for AUTOLOAD_FILE_PATTERN, File.dirname(__FILE__)
Application.new.run :landing, :index