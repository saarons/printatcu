module PrintHelper
  def buildings
    $buildings.sort
  end
  
  def choose_building
    flash[:building].present? ? flash[:building] : nil
  end
  
  def choose_printer
    flash[:printer].present? ? flash[:printer] : nil
  end
  
  def default_printer
    if @print.printer.present?
      $printers[@print.building]
    elsif flash[:printer].present?
      $printers[flash[:building]]
    else
      $printers[buildings.first]
    end
  end
end
