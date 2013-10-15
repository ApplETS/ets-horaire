require_relative 'cli/auto_complete_folder_contents'

class View
  def initialize(controller, instance_variables, flash = {})
    @controller = controller
    @flash = flash

    instance_variables.each_pair do |key, value|
      instance_variable_set key, value
    end
  end

  def flash_notice
    if @flash.has_key?(:notice)
      puts @flash[:notice]
      puts ""
    end
  end

  def readline_to(variable_name, controller_method)
    params = {}
    AutoCompleteFolderContents.in_context { params[variable_name.to_s] = readline }
    @controller.execute controller_method, params
  end
end