class AddIdentifierToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :identifier, :string
  end

  def self.down
    remove_column :notifications, :identifier
  end
end
