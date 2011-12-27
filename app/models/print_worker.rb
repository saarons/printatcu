class PrintWorker
  @queue = :printing

  def self.perform(print_id)
    print = Print.find(print_id)
    
    print.documents.each do |document|
      ok = if document.needs_conversion?
        document.convert
      else
        true
      end

      document.print if ok
    end
  end
end