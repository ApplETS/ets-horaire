class BachelorCoursesWebPageRow
  PROFILE_TITLE = /^Profil ([A-Z]+) \(.+\)/
  COURSE_ROW = /^([A-Z]{3}\d{3})\** .+ \((\d) cr\.\)( \((.+)\))?/
  ALL_PROFILES_TITLE = 'Tous les profils'
  PREREQUISITES_PROFILE = /^profil[s] ?(.*): ([A-Z]{3}\d{3})/
  COURSE = /([A-Z]{3}\d{3})/

  PROFILE_NAME_INDEX = 1
  COURSE_NAME_INDEX = 1
  NB_CREDITS_INDEX = 2
  PREREQUISITES_INDEX = 4

  Prerequisite = Struct.new(:course_name, :profiles)

  attr_reader :profile_name, :course_name, :nb_credits, :prerequisites

  def self.analyze(row_node)
    new row_node
  end

  private_class_method :new
  def initialize(row_node)
    @row_text = normalize(row_node)

    @profile_matches = PROFILE_TITLE.match(@row_text)
    @course_matches = COURSE_ROW.match(@row_text)

    profile_matches = @profile_matches || []
    course_matches = @course_matches || []

    @profile_name = profile_matches[PROFILE_NAME_INDEX]
    @course_name = course_matches[COURSE_NAME_INDEX]
    @nb_credits = course_matches[NB_CREDITS_INDEX]
    @prerequisites = parse_prerequisites(course_matches)
  end

  def profile_line?
    !@profile_matches.nil?
  end

  def course_line?
    !@course_matches.nil?
  end

  def all_profiles_line?
    @row_text == ALL_PROFILES_TITLE
  end

  private

  def normalize(row_node)
    row_node.text.strip.gsub(/\r|\n/, '').gsub(/\s+/, ' ')
  end

  def parse_prerequisites(course_matches)
    prerequisites_text = course_matches[PREREQUISITES_INDEX]
    return nil if prerequisites_text.nil?

    prerequisites_collection = prerequisites_text.split(';')
    prerequisites_collection.collect do |prerequisite_part|
      cleaned_prerequisite_part = prerequisite_part.strip.gsub(/\*/, '')

      prerequisite_matches = PREREQUISITES_PROFILE.match(cleaned_prerequisite_part)
      course_match = COURSE.match(cleaned_prerequisite_part)

      if !prerequisite_matches.nil?
        parse_profile_prerequisites(prerequisite_matches)
      elsif !course_match.nil?
        course_name = course_match[1]
        Prerequisite.new course_name, nil
      else
        prerequisites_text
      end
    end
  end

  def parse_profile_prerequisites(prerequisite_matches)
    course_name = prerequisite_matches[2]
    profiles = prerequisite_matches[1].split(/[ |,|et]+/)
    Prerequisite.new course_name, profiles
  end
end