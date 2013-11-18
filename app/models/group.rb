# -*- encoding : utf-8 -*-

class Group
  attr_reader :nb, :periods

  def initialize(nb, periods)
    @nb = nb
    @periods = periods
  end
end
