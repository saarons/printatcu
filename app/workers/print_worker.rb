class PrintWorker
  @queue = :printing
  def self.perform(print_id, filename, url, building, printer, user, double_sided, collate, copies, ip)

    document = Document.new(print_id: print_id, filename: filename, url: url)
    print = Print.new(building: building, printer: printer, user: user, double_sided: double_sided, collate: collate, copies: copies, ip: ip)
    document.print = print
    document.fetch
    
    ok = document.needs_conversion? ? document.convert : true

    if ok
      document.enqueue
      document.announce
    end

    document.cleanup
  end

end