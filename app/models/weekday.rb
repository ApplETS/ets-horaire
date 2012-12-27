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
      index = LANGUAGES[lang].index { |weekday| weekday == name.downcase }
      Weekday.new index
    end

    define_singleton_method(short_lang_downcase) do |name|
      index = LANGUAGES[lang].index { |weekday| weekday[0..2] == name.downcase }
      Weekday.new index
    end

    define_method(lang_downcase) { LANGUAGES[lang][@index] }
  end

end