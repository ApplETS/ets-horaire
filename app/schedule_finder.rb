require_relative "conditional_combinator"
require_relative "models/fully_descriptive_group"

class ScheduleFinder

  def self.combinations_for(courses, courses_per_schedule)
    group_courses = flatten(courses)
    ConditionalCombinator.find_combinations(group_courses, courses_per_schedule) do |groups_combinations, group|
      conflicts_with? groups_combinations, group
    end
  end

  private

  def self.flatten(courses)
    periods = courses.collect do |course|
      course.groups.collect do |group|
        FullyDescriptiveGroup.new(course.name, group.nb).with *group.periods
      end
    end
    periods.flatten
  end

  def self.conflicts_with?(groups_combinations, group)
    index = groups_combinations.index do |comparable_group_course|
      comparable_group_course.conflicts?(group)
    end
    index.nil?
  end

end