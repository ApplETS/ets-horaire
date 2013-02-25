class Convert

  def self.pdf_to_text(pdf_path)
    input_path = "#{pdf_path}.pdf"
    output_path = "#{pdf_path}.txt"

    command_output = convert_using_system_command(input_path, output_path)

    raise "Warning! pdftotext executed with output #{command_output}" unless command_output.empty?
    File.open(output_path, "r")
  end

  private

  def self.convert_using_system_command(input_path, output_path)
    `pdftotext -enc UTF-8 -layout #{input_path} #{output_path}`
  end

end