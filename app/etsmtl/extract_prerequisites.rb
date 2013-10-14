class ExtractPrerequisites
  COURSES = /\((([A-Z]{3}\d{3}\*?|,| |ou)+)\)/
  COURSE_INDEX = 1

  Course = Struct.new(:name, :type)
  Relation = Struct.new(:type, :courses)

  def self.from(prerequisites_text)
    course_match = COURSES.match(prerequisites_text)
    course_names = extract_courses(course_match)
    relation_type = (prerequisites_text.include?('ou') ? :or : :and)

    courses = course_names.collect do |course_name|
      filtered_course_name = course_name.gsub('*', '')
      flag = (course_name[-1] == '*')
      course_type = (flag ? :prerequisite_or_concurrent : :prerequisite)
      Course.new(filtered_course_name, course_type)
    end

    Relation.new relation_type, courses
  end

  private

  def self.extract_courses(course_match)
    course_names_text = course_match[COURSE_INDEX]
    course_names_text.split(/[,| |ou]+/)
  end
end