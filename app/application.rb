# -*- encoding : utf-8 -*-

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
