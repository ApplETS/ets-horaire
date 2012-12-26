class Group

  attr_reader :nb, :periods

  def initialize(nb)
    @nb = nb
    @periods = []
  end

  def with(*periods)
    @periods = periods
    self
  end

end