class Print < ActiveRecord::Base
  attr_protected :user
  
  has_many :documents
  
  validates_presence_of :building, :printer, :user, :copies
  validates_inclusion_of :double_sided, :collate, :in => [true, false]
  validates_numericality_of :copies, :greater_than_or_equal_to => 1, :less_than => 100, :only_integer => true
end
