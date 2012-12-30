class SchedulePrinter

  def self.print(schedule, stream)
    stream.write "     -------------------------------------------------------------------------------------"
    stream.write "     |Lundi          ||Mardi          ||Mercredi       ||Jeudi          ||Vendredi       |"
    stream.write "     -------------------------------------------------------------------------------------"
  end

end