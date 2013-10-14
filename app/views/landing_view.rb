# encoding: utf-8

require 'colorize'
require_relative '../view'

class LandingView < View
  def render
    puts "* * * * * * * * * * * * * * * * * * *".blue
    puts "*                                   *".blue
    puts "*   Calculateur d'horaire à l'ÉTS   *".blue
    puts "*                                   *".blue
    puts "* * * * * * * * * * * * * * * * * * *".blue
    puts ""
  end
end