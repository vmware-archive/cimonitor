class AddTrackerAttributesToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :tracker_url, :string
    add_column :projects, :tracker_api_key, :string
    add_column :projects, :tracker_release_deadline, :datetime
    add_column :projects, :tracker_release_status, :string
    add_column :projects, :tracker_updated_at, :timestamp
  end

  def self.down
    remove_column :projects, :tracker_url
    remove_column :projects, :tracker_api_key
    remove_column :projects, :tracker_release_deadline
    remove_column :projects, :tracker_release_status
    remove_column :projects, :tracker_updated_at
  end
end
