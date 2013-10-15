require_relative '../app/controllers/input_controller'
require_relative '../app/controllers/landing_controller'
require_relative '../app/controllers/output_controller'

class Application
  def run(controller_name, controller_method)
    controllers = {
      'input' => InputController.new,
      'landing' => LandingController.new,
      'output' => OutputController.new
    }

    controllers.values.each { |controller| controller.controllers = controllers }

    controller = controllers[controller_name.to_s]
    controller.execute controller_method.to_s
  end
end