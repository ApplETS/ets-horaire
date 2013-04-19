class PeriodMatcher
  LINE_MATCHER = /^\f?\s*(\w{3})\s*(\d{2}:\d{2})\s-\s(\d{2}:\d{2})\s*(([\d\w\/\-\\+]+\s?)+)/i

  def self.extract(line)
    LINE_MATCHER.match(line)
  end
end