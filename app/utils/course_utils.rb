# -*- encoding : utf-8 -*-

class CourseUtils

  def self.cleanup!(courses)
    remove_duplicates_from courses
  end

  private

  def self.remove_duplicates_from(courses)
    courses.uniq! { |course| course.name }
  end

end
