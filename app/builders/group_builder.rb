require_relative "../builders/period_builder"
require_relative "../models/group"

class GroupBuilder

  def self.build(group_struct)
    periods = group_struct.periods.collect { |period_struct| PeriodBuilder.build period_struct }
    Group.new(group_struct.nb).with *periods
  end

end