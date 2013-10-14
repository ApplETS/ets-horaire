require 'readline'

class AutoCompleteReadline
  def self.readline
    @@autocomplete_proc ||= Proc.new do |input|
      escaped_input = Regexp.escape(input)
      starting_regexp = %r(^#{escaped_input})

      listing = Dir["#{input}*"]
      listing = listing.collect do |entry|
        File.directory?(entry) ? "#{entry}/" : entry
      end
      listing.grep starting_regexp
    end

    completion_append_character = Readline.completion_append_character
    completion_proc = Readline.completion_proc

    Readline.completion_append_character = ''
    Readline.completion_proc = @@autocomplete_proc

    yield Readline.readline

    Readline.completion_append_character = completion_append_character
    Readline.completion_proc = completion_proc
  end
end