class AddTrackerFieldsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :tracker_enabled, :boolean, :default => false
    add_column :projects, :tracker_token, :string
    add_column :projects, :tracker_id, :integer
  end

  def self.down
    remove_column :projects, :tracker_enabled
    remove_column :projects, :tracker_token
    remove_column :projects, :tracker_id
  end
end
