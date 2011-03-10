class AddLocaleToTripSegment < ActiveRecord::Migration
  def self.up
    add_column :trip_segments, :origin_id, :integer, :null => true
    add_column :trip_segments, :destination_id, :integer, :null => true
  end

  def self.down
    remove_column :trip_segments, :origin_id
    remove_column :trip_segments, :destination_id
  end
end
