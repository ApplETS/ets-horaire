# -*- encoding : utf-8 -*-
require 'colorize'

class OutputView < View
  def index
    puts ""
    puts "Utilisation du fichier: ".light_blue + @config_file_path.yellow
    puts ""

    @output_types.each do |output_type|
      if @possible_output_types.include? output_type
        output_destination = @output_destinations[output_type]
        puts "(#{output_type}) Écriture des résultats dans: ".green + output_destination.yellow
      else
        puts "Le type '#{output_type}' n'existe pas. Ignorant le type.".red
      end
    end
  end
end
