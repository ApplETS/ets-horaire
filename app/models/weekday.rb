# -*- encoding : utf-8 -*-

class Weekday

  LANGUAGES = {
    EN: %w(monday tuesday wednesday thursday friday saturday sunday),
    FR: %w(lundi mardi mercredi jeudi vendredi samedi dimanche)
  }

  attr_reader :index

  def initialize(index)
    @index = index
  end

  LANGUAGES.keys.each do |lang|
    lang_downcase = lang.downcase
    short_lang_downcase = "short_#{lang_downcase}".to_sym

    define_singleton_method(lang_downcase) do |name|
      create_weekday_using(lang, name) { |weekday| weekday == name.downcase }
    end

    define_singleton_method(short_lang_downcase) do |name|
      create_weekday_using(lang, name) { |weekday| weekday[0..2] == name.downcase }
    end

    define_method(lang_downcase) { LANGUAGES[lang][@index] }
  end

  private

  def self.create_weekday_using(lang, name, &block)
    index = LANGUAGES[lang].index(&block)
    raise "'#{name}' is not a valid weekday." if index.nil?
    Weekday.new index
  end

end
