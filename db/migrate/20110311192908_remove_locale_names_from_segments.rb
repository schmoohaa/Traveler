class RemoveLocaleNamesFromSegments < ActiveRecord::Migration
  def self.up
    remove_column :trip_segments, :origin
    remove_column :trip_segments, :destination
  end

  def self.down
  end
end
