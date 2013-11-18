# -*- encoding : utf-8 -*-

class CourseBuilder
  def self.build(course)
    groups = course.groups.collect { |group_struct| GroupBuilder.build group_struct }
    Course.new(course.name, groups)
  end
end
