# -*- encoding : utf-8 -*-

class GroupBuilder

  def self.build(group_struct)
    periods = group_struct.periods.collect { |period_struct| PeriodBuilder.build period_struct }
    Group.new(group_struct.nb, periods)
  end

end
