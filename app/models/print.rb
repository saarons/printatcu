class Print < ActiveRecord::Base
  attr_protected :user
  
  has_many :documents, :validate => false
  
  validate :validate_documents
  validates_presence_of :building, :printer, :user, :copies
  validates_inclusion_of :double_sided, :collate, :in => [true, false]
  validates_numericality_of :copies, :greater_than_or_equal_to => 1, :less_than => 100, :only_integer => true
  
  private
  def validate_documents
    errors.add(:documents, "are needed for printing") if documents.empty?
    invalid = false
    documents.each do |document|
      unless ALL_EXTENSIONS.include?(document.extension)
        errors.add(:base, "#{document.filename} can't be printed") 
        invalid = true
      end
    end
    errors.add(:documents, "must end with a valid extension (#{ALL_EXTENSIONS.join(", ")})") if invalid
  end
end
