# -*- encoding : utf-8 -*-

class CourseGroup < Group

  attr_reader :course_name

  def initialize(course_name, group_nb)
    super group_nb
    @course_name = course_name
  end

  def conflicts?(group)
    same_course_name?(group) || periods_conflict?(group)
  end

  private

  def same_course_name?(group)
    @course_name == group.course_name
  end

  def periods_conflict?(group)
    periods.any? do |period|
      group.periods.any? { |comparable_period| period.conflicts?(comparable_period) }
    end
  end

end
