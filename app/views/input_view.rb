# encoding: utf-8

require 'colorize'
require_relative '../view'

class InputView < View
  def render(&block)
    puts "Veuillez rentrer le ficher de configuration:".light_blue

    instance_eval &block

    if @file_exists
      puts ""
      puts "Utilisation du fichier: ".light_blue + @config_file_path.yellow
      puts ""
    else
      puts "Fichier invalide: ".red + @config_file_path.yellow
    end
  end
end