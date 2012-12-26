class Course

  attr_reader :name, :groups

  def initialize(name)
    @name = name
    @groups = []
  end

  def with(*groups)
    raise "All of the group numbers must be unique." if !unique_group_nb?(groups)
    @groups = groups
    self
  end

  def conflicts?(course)
    !@groups.index do |group|
      !course.groups.index { |comparable_group| group.conflicts?(comparable_group) }.nil?
    end.nil?
  end

  private

  def unique_group_nb?(groups)
    groups.index do |group|
      groups_duplicate = groups.dup
      groups_duplicate.delete(group)
      !groups_duplicate.index { |group_duplicate| group.nb == group_duplicate.nb }.nil?
    end.nil?
  end

end