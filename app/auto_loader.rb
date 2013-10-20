# -*- encoding : utf-8 -*-
class AutoLoader
  @@load_paths = {}

  class << self
    def load_paths
      @@load_paths
    end

    def setup_autoload_for(file_patterns)
      file_patterns.each do |file_pattern|
        Dir[file_pattern].each do |filename|
          class_name = to_camel_case(filename)
          @@load_paths[class_name] = filename
        end
      end
    end

    private

    def to_camel_case(filename)
      basename = Pathname.new(filename).basename.to_s
      basename_without_ruby_extension = basename[0..-4]
      camel_case_parts = basename_without_ruby_extension.split('_').collect { |part| part[0].upcase + part[1..-1] }
      camel_case_parts.join.to_sym
    end
  end
end

class Object
  class << self
    alias_method :old_const_missing, :const_missing

    def const_missing(constant_name)
      file_path = AutoLoader.load_paths[constant_name]

      if file_path.nil?
        old_const_missing constant_name
      else
        require file_path
        const_get constant_name
      end
    end
  end
end
