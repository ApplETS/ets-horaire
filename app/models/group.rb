class Group

  attr_reader :nb, :periods

  def initialize(nb)
    @nb = nb
  end

  def with(*periods)
    @periods = periods
    self
  end

  def conflicts?(group)
    !@periods.index do |period|
      !group.periods.index { |comparable_period| period.conflicts?(comparable_period) }.nil?
    end.nil?
  end

end