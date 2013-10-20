# -*- encoding : utf-8 -*-

class Controller
  IGNORE_INSTANCE_VARIABLES = %w(@params @flash @controllers)

  attr_reader :params, :flash
  attr_writer :controllers

  def initialize
    @flash = {}
  end

  def redirect_to(controller_method, controller_name = nil, params = {})
    @render_view = false
    controller = (controller_name.nil? ? self : @controllers[controller_name.to_s])
    controller.execute controller_method, params
  end

  def execute(method_name, params = {})
    @render_view = true
    @params = params

    send method_name
    render(method_name) if @render_view
  end

  def render(method_name, &block)
    @render_view = false

    class_name = self.class.name.sub('Controller', '')
    view_name = "#{class_name}View"
    view = Kernel.const_get(view_name)
    view.new(self, instance_variables_hash, @flash).send(method_name, &block)
  end

  private

  def instance_variables_hash
    hash = {}
    instance_variables.each do |instance_variable|
      key = instance_variable.to_s
      hash[key] = instance_variable_get(key) unless IGNORE_INSTANCE_VARIABLES.include?(key)
    end
    hash
  end
end
