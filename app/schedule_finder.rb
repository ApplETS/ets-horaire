require_relative "conditional_combinator"

class ScheduleFinder

  def self.combinations(courses, courses_per_schedule)
    ConditionalCombinator.find_combinations(courses, 4) do |courses_combinations, course|
      conflicts_with? courses_combinations, course
    end
  end

  private

  def self.conflicts_with?(courses_combinations, course)
    courses_combinations.index do |comparable_course|
      comparable_course.conflicts?(course)
    end.nil?
  end

end