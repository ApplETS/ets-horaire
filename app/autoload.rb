def setup_autoload_for(file_pattern, basepath)
  $:.unshift basepath

  Dir[file_pattern].each do |filename|
    class_name = to_camel_case(filename)
    filepath = File.join(basepath, filename)
    autoload class_name, filepath
  end
end

def to_camel_case(filename)
  basename = Pathname.new(filename).basename.to_s
  basename_without_ruby_extension = basename[0..-4]
  camel_case_parts = basename_without_ruby_extension.split('_').collect { |part| part[0].upcase + part[1..-1] }
  camel_case_parts.join.to_sym
end