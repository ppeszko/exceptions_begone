class ChangeIdentifierColumnTypeForNotifications < ActiveRecord::Migration
  def self.up
    change_column :notifications, :identifier, :text
  end

  def self.down
    change_column :notifications, :identifier, :string
  end
end
