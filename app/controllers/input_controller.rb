# -*- encoding : utf-8 -*-
require 'colorize'
require_relative '../controller'
require_relative '../views/input_view'

class InputController < Controller
  def index
  end

  def post
    config_file_path = params['config_file_path']
    file_exists = !File.directory?(config_file_path) && File.exists?(config_file_path)

    if file_exists
      redirect_to :index, :output, { config_file_path: config_file_path }
    else
      flash[:notice] = "Fichier invalide: ".red + config_file_path.yellow
      render 'index'
    end
  end
end
