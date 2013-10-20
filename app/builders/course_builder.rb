# -*- encoding : utf-8 -*-

class CourseBuilder

  def self.build(course_struct)
    groups = course_struct.groups.collect { |group_struct| GroupBuilder.build group_struct }
    Course.new(course_struct.name).with *groups
  end

end
