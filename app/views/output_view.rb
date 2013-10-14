# encoding: utf-8

require 'colorize'
require_relative '../view'

class OutputView < View
  def render
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