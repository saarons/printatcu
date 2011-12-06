class PrintWorker
  @queue = :printing

  def self.perform(print_id)
    print = Print.find(print_id)
    
    ok = if print.needs_conversion?
      print.convert
    else
      true
    end
    
    print.print if ok
  end
end