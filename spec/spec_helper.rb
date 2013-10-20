# -*- encoding : utf-8 -*-
require_relative '../app/auto_loader'

AUTOLOAD_FILE_PATTERN = [
  File.expand_path(File.join(File.dirname(__FILE__), '../app/**/*.rb'))
]
SUPPORT_FILES = File.expand_path(File.join(File.dirname(__FILE__), 'support/**/*.rb'))

RSpec.configure do
  AutoLoader.setup_autoload_for AUTOLOAD_FILE_PATTERN

  Dir[SUPPORT_FILES].each { |file| require file }
end
