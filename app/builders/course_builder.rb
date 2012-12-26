require_relative "../builders/group_builder"
require_relative "../models/course"

class CourseBuilder

  def self.build(course_struct)
    groups = course_struct.groups.collect { |group_struct| GroupBuilder.build group_struct }
    Course.new(course_struct.name).with *groups
  end

end