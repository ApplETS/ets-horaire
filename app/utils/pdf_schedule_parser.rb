CourseStruct = Struct.new(:name, :groups) if !defined?(CourseStruct)
GroupStruct = Struct.new(:nb, :periods) if !defined?(GroupStruct)
PeriodStruct = Struct.new(:weekday, :start_time, :end_time, :type) if !defined?(PeriodStruct)

class PdfScheduleParser

	COURSE_REGEX = /^\f?(\w{3}\d{3})/i
	GROUP_REGEX = /^\f?\s*(\d{1,2})\s*(\w{3})\s*(\d{2}:\d{2})\s-\s(\d{2}:\d{2})\s*(([\d\w\/\-\\+]+\s?)+)/i
	PERIOD_REGEX = /^\f?\s*(\w{3})\s*(\d{2}:\d{2})\s-\s(\d{2}:\d{2})\s*(([\d\w\/\-\\+]+\s?)+)/i

	def self.extract_courses(filepath)
		pdf = File.new(filepath, "r")

		courses = []
		course = nil
		group = nil
		
		while (line = pdf.gets)
			course_match_data = COURSE_REGEX.match(line)
			group_match_data = GROUP_REGEX.match(line)
			period_match_data = PERIOD_REGEX.match(line)

			if !course_match_data.nil?
				course = CourseStruct.new(course_match_data[1], [])
				courses << course
			elsif !group_match_data.nil? && !course.nil?
				group = GroupStruct.new(group_match_data[1].to_i, [])
				group.periods << build_period(group_match_data[2..5])
				course.groups << group
			elsif !period_match_data.nil? && !group.nil?
				group.periods << build_period(period_match_data[1..4])
			end
		end
		
		pdf.close
		courses
	end

	private

	def self.build_period(attributes)
		attributes[3].gsub!(/[\s\n]$/ , "")
    PeriodStruct.new *attributes
	end

end