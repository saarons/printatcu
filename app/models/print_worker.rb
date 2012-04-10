class PrintWorker
  @queue = :printing

  def self.perform(document_id)
    document = Document.find(document_id)
    ok = document.needs_conversion? ? document.convert : true
    if ok
      document.enqueue
      $redis.publish("print", ActiveSupport::JSON.encode({building: document.print.building}))
    end
    document.cleanup
  end
end