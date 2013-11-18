# -*- encoding : utf-8 -*-

class Course
  attr_reader :name, :groups

  def initialize(name, groups)
    raise "All of the group numbers must be unique." if !unique_group_nb?(groups)

    @name = name
    @groups = groups
  end

  private

  def unique_group_nb?(groups)
    groups.none? do |group|
      groups_duplicate = groups.dup
      groups_duplicate.delete(group)
      groups_duplicate.any? { |group_duplicate| group.nb == group_duplicate.nb }
    end
  end

end
