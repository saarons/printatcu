module PrintHelper
  def buildings
    $buildings.sort
  end
  
  def default_printer
    @print.printer.present? ? $printers[@print.building] : $printers[buildings.first]
  end
  
  def success_message
    user = flash[:user]
    printer = flash[:printer]
    phrase = flash[:multiple] ? "documents have" : "document has"
    
    "Your #{phrase} been successfully sent to <strong>#{printer}</strong> under the pseudonym \"<strong>#{user}</strong>\".".html_safe
  end
end
