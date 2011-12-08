module PrintHelper
  def buildings
    $buildings.sort
  end
  
  def default_printer
    @print.printer.present? ? $printers[@print.building] : $printers[buildings.first]
  end
end
