require_relative 'line_matchers/course_matcher'
require_relative 'line_matchers/group_matcher'
require_relative 'line_matchers/period_matcher'

class PdfScheduleParser

  CourseStruct = Struct.new(:name, :groups)
  GroupStruct = Struct.new(:nb, :periods)
  PeriodStruct = Struct.new(:weekday, :start_time, :end_time, :type)

	def self.extract_courses_from(stream)
		courses = []
		course = nil
		group = nil
		
		while (line = stream.gets)
			course_match_data = CourseMatcher.extract(line)
			group_match_data = GroupMatcher.extract(line)
			period_match_data = PeriodMatcher.extract(line)

			if !course_match_data.nil?
				course = CourseStruct.new(course_match_data[1], [])
				courses << course
			elsif !group_match_data.nil? && !course.nil? && course.name != 'PRE010'
				group = GroupStruct.new(group_match_data[1].to_i, [])
				group.periods << build_period(group_match_data[2..5])
				course.groups << group
			elsif !period_match_data.nil? && !group.nil? && course.name != 'PRE010'
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

end