class Exclusion
  include MongoMapper::Document
  
  key :name
  key :enabled
  key :pattern
  timestamps!

  belongs_to :project
  
  validates_presence_of :name
  validates_presence_of :pattern
  
  # named_scope :active, :conditions => ["enabled = ?", true]
  
end
