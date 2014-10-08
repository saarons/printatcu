class PrintWorker
  @queue = :printing
    t.string   "building"
    t.string   "printer"
    t.string   "user"
    t.boolean  "double_sided", :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "collate"
    t.integer  "copies"
    t.string   "ip"
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