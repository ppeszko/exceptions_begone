class BiggerIdentifierColumn < ActiveRecord::Migration
  def self.up
    change_column :stacks, :identifier, :text
  end

  def self.down
    change_column :stacks, :identifier, :string
  end
end
