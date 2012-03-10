module PrintHelper
  def buildings
    $buildings.sort
  end
  
  def choose_building
    if @print.building.present?
      @print.building
    elsif flash[:building].present?
      flash[:building]
    end
  end
  
  def choose_printer
    if @print.printer.present?
      @print.printer
    elsif flash[:printer].present?
      flash[:printer]
    end
  end
  
  def default_printer
    building = if @print.building.present?
      @print.building
    elsif flash[:printer].present?
      flash[:building]
    else
      buildings.first
    end
    $printers[building]
  end
end
