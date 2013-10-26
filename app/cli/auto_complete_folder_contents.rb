# -*- encoding : utf-8 -*-

require 'readline'

class AutoCompleteFolderContents
  def self.readline
    Readline.readline('', true).chomp
  end

  def self.in_context(&block)
    @@autocomplete_proc ||= initialize_autocomplete_proc

    completion_append_character = Readline.completion_append_character
    completion_proc = Readline.completion_proc || Proc.new {}

    Readline.completion_append_character = ''
    Readline.completion_proc = @@autocomplete_proc

    class_eval &block

    Readline.completion_append_character = completion_append_character
    Readline.completion_proc = completion_proc
  end

  private

  def self.initialize_autocomplete_proc
    Proc.new do |input|
      escaped_input = Regexp.escape(input)
      starting_regexp = %r(^#{escaped_input})

      folder_contents = Dir["#{input}*"]
      folder_contents = folder_contents.collect do |entry|
        File.directory?(entry) ? "#{entry}/" : entry
      end
      folder_contents.grep starting_regexp
    end
  end
end
