class PrintWorker
  @queue = :printing

  def self.perform(document_id)
    document = Document.find(document_id)
    ok = document.needs_conversion? ? document.convert : true
    document.enqueue if ok
  end
end