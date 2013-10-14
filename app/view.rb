class View
  def initialize(parameters = {})
    parameters.each_pair { |key, value| instance_variable_set "@#{key}", value }
  end

  def set(key, value)
    instance_variable_set "@#{key.to_s}", value
  end
end