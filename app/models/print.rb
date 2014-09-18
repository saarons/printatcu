class Print < ActiveRecord::Base
  attr_protected :user
  
  has_many :documents

  validates_presence_of :building, :printer, :user, :copies
  validates_inclusion_of :double_sided, :collate, :in => [true, false]
  validates_numericality_of :copies, :greater_than_or_equal_to => 1, :less_than => 100, :only_integer => true

  def enqueue
    document_ids.map do |document_id|
      Document.find(document_id).save
      document = Document.find(document_id)
      document.fetch
      
      ok = document.needs_conversion? ? document.convert : true

      if ok
        document.enqueue
        document.announce
      end

      document.cleanup
    end
  end

  def build_documents(urls)
    urls.each do |url|
      new_document = documents.build
      new_document.url = url
    end
  end
end
