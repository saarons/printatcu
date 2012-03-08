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
    flash[:printer].present? ? flash[:printer] : nil
  end
  
  def default_printer
    if @print.building.present?
      $printers[@print.building]
    elsif flash[:printer].present?
      $printers[flash[:building]]
    else
      $printers[buildings.first]
    end
  end
end
