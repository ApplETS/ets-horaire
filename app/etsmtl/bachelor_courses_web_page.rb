require_relative 'extract_profile_names'
require_relative 'bachelor_courses_web_page_row'
require 'nokogiri'
require 'open-uri'

module ETSMtl
  class BachelorCoursesWebPage
    COURSES_NODE_ID = 'plc_lt_zoneMain_pageplaceholder_pageplaceholder_lt_zoneContent_pageplaceholder_pageplaceholder_lt_zoneCenter_pageplaceholder_pageplaceholder_lt_zoneLeft_repeater_repItems_ctl00_ctl00_PanelCoursASuivre'

    Profile = Struct.new(:name, :courses)
    Course = Struct.new(:name, :nb_credits, :prerequisites)

    def self.parse(url)
      new(url)
    end

    private_class_method :new
    def initialize(url)
      web_page = open(url)
      document = Nokogiri::HTML(web_page)

      profile_names = ExtractProfileNames.from(document)
      profiles = create_profile_dictionary(profile_names)
      current_profile_section = nil

      document.css("##{COURSES_NODE_ID} tr").each do |row_node|
        row = BachelorCoursesWebPageRow::analyze(row_node)

        if row.profile_line?
          current_profile_section = row.profile_name
        elsif row.all_profiles_line?
          current_profile_section = nil
        elsif row.course_line?
          p "#{row.course_name} - #{row.prerequisites}"

          course = Course.new(row.course_name, row.nb_credits, row.prerequisites)

          if current_profile_section.nil?
            profiles.each_pair { |profile_name, courses| courses << course }
          else
            profiles[current_profile_section] << course
          end
        end
      end
    end

    private

    def create_profile_dictionary(profile_names)
      profile_names << 'default' if profile_names.empty?

      profiles = {}
      profile_names.each { |profile_name| profiles[profile_name] = [] }
      profiles
    end
  end
end