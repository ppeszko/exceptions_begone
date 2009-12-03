class Project < ActiveRecord::Base
  has_many :stacks
  has_many :exclusions
end