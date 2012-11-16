class Print < ActiveRecord::Base
  attr_protected :user
  
  has_many :documents, :validate => false
  
  validate :validate_documents
  validates_presence_of :building, :printer, :user, :copies
  validates_inclusion_of :double_sided, :collate, :in => [true, false]
  validates_numericality_of :copies, :greater_than_or_equal_to => 1, :less_than => 100, :only_integer => true

  def enqueue
    document_ids.map do |document_id|
      Resque.enqueue(PrintWorker, document_id)
    end
  end
  
  private
  def validate_documents
    errors.add(:documents, :no_documents) if documents.empty?
    invalid = false
    documents.each do |document|
      unless document.is_url? || ALL_EXTENSIONS.include?(document.extension)
        errors.add(:base, :unable_to_print, :filename => document.filename)
        invalid = true
      end
    end
    errors.add(:documents, :invalid_extension, :list => ALL_EXTENSIONS.join(", ")) if invalid
  end
end
