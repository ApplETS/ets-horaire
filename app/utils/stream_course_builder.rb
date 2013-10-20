# -*- encoding : utf-8 -*-

class StreamCourseBuilder

  CourseStruct = Struct.new(:name, :groups)
  GroupStruct = Struct.new(:nb, :periods)
  PeriodStruct = Struct.new(:weekday, :start_time, :end_time, :type)

	def self.build_courses_from(stream)
		courses = []
		course = nil
		group = nil

    stream.each do |line|
			course_match_data = LineMatcher.course(line)
			group_match_data = LineMatcher.group(line)
			period_match_data = LineMatcher.period(line)

			if course_line?(course_match_data)
				course = CourseStruct.new(course_match_data[1], [])
				courses << course
			elsif group_line?(course, group_match_data)
				group = GroupStruct.new(group_match_data[1].to_i, [])
				group.periods << build_period(group_match_data[2..5])
				course.groups << group
			elsif period_line?(course, group, period_match_data)
				group.periods << build_period(period_match_data[1..4])
			end
		end

    stream.close
		courses
	end

  private

  def self.build_period(attributes)
    attributes[3].gsub!(/[\s\n]$/ , '')
    PeriodStruct.new *attributes
  end

  def self.course_line?(course_match_data)
    !course_match_data.nil?
  end

  def self.group_line?(course, group_match_data)
    !(group_match_data.nil? || course.nil? || course.name == 'PRE010')
  end

  def self.period_line?(course, group, period_match_data)
    !(period_match_data.nil? || group.nil? || course.name == 'PRE010')
  end

end
