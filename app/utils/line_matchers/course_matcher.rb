class CourseMatcher
  LINE_MATCHER = /^\f?(\w{3}\d{3})/i

  def self.extract(line)
    LINE_MATCHER.match(line)
  end
end