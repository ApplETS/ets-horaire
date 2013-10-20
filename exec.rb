# -*- encoding : utf-8 -*-

require 'rubygems'
require 'pathname'
require_relative 'app/auto_loader'

AUTOLOAD_FILE_PATTERN = [
  File.expand_path(File.join(File.dirname(__FILE__), 'app/**/*.rb'))
]

AutoLoader.setup_autoload_for AUTOLOAD_FILE_PATTERN
Application.new.run :landing, :index
