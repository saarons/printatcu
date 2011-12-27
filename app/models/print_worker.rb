class PrintWorker
  @queue = :printing

  def self.perform(print_id)
    print = Print.find(print_id)
    
    print.documents.each do |document|
      unless document.printed?
        ok = document.needs_conversion? ? document.convert : true
        document.dispatch if ok
        document.save
      end
    end
  end
end