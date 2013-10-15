# encoding: utf-8

require 'colorize'
require_relative '../view'

class InputView < View
  def index
    flash_notice
    puts "Veuillez rentrer le ficher de configuration:".light_blue
    readline_to :config_file_path, :post
  end
end