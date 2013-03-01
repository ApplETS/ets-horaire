class Convert

  def self.pdf_to_text(pdf_path)
    input_path = "#{pdf_path}.pdf"
    output_path = "#{pdf_path}.txt"
    command_output = nil

    execute_command(input_path, output_path) { |stdin| command_output = stdin.gets }

    raise "Warning! pdftotext executed with output #{command_output}" unless command_output.nil?
    File.open(output_path, "r")
  end

  private

  def self.execute_command(input_path, output_path, &block)
    IO.popen("pdftotext -enc UTF-8 -layout #{input_path} #{output_path}", &block)
  end

end