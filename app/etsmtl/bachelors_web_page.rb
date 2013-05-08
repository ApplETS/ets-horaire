require 'nokogiri'
require 'open-uri'

module ETSMtl
  class BachelorsWebPage
    BASE_URL = 'http://etsmtl.ca'
    BACHELORS_URL = "#{BASE_URL}/Futurs-etudiants/Baccalaureat/Programmes-d-etudes/Bac"
    BACHELOR_NODE_ID = '#etsMCContent'

    Bachelor = Struct.new(:name, :url)

    attr_reader :bachelors

    def self.parse
      new
    end

    private_class_method :new
    def initialize
      web_page = open(BACHELORS_URL)
      document = Nokogiri::HTML(web_page)

      @bachelors = document.css("#{BACHELOR_NODE_ID} tr").collect do |line|
        bachelor_name_node = line.css('td:nth-child(1)')
        bachelor_name = bachelor_name_node.text

        bachelor_link_node = line.css('td:nth-child(3) a')
        bachelor_path = bachelor_link_node.attr('href').value
        bachelor_url = "#{BASE_URL}#{bachelor_path}"

        Bachelor.new bachelor_name, bachelor_url
      end
    end
  end
end