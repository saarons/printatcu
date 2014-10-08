class Print < ActiveRecord::Base
  attr_protected :user
  
  has_many :documents

  validates_presence_of :building, :printer, :user, :copies
  validates_inclusion_of :double_sided, :collate, :in => [true, false]
  validates_numericality_of :copies, :greater_than_or_equal_to => 1, :less_than => 100, :only_integer => true

  def enqueue
    document_ids.map do |document_id|
      doc = Document.find(document_id)
      Resque.enqueue(PrintWorker, doc.print_id, doc.filename, doc.url, doc.print.url, doc.print.building, doc.print.printer, doc.print.user, doc.print.double_sided, doc.print.collate, doc.print.copies, doc.print.ip)
    end
  end

  def build_documents(urls)
    urls.each do |url|
      new_document = documents.build
      new_document.url = url
    end
  end
end
