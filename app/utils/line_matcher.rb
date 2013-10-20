# -*- encoding : utf-8 -*-

class LineMatcher
  COURSE = /^\f?(\w{3}\d{3})/i
  GROUP = /^\f?\s*(\d{1,2})\s*(\w{3})\s*(\d{2}:\d{2})\s-\s(\d{2}:\d{2})\s*(([\d\w\/\-\\+]+\s?)+)/i
  PERIOD = /^\f?\s*(\w{3})\s*(\d{2}:\d{2})\s-\s(\d{2}:\d{2})\s*(([\d\w\/\-\\+]+\s?)+)/i

  def self.course(line)
    COURSE.match(line)
  end

  def self.group(line)
    GROUP.match(line)
  end

  def self.period(line)
    PERIOD.match(line)
  end
end
