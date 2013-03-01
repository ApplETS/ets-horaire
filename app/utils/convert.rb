class Convert

  def self.pdf_to_text(pdf_path)
    IO.popen("pdftotext -enc UTF-8 -layout #{pdf_path}.pdf \"-\"")
  end

end