class ConnectTripToTripSegment < ActiveRecord::Migration
  def self.up
    say "creating the trip key in trip_segments....."
    add_column :trip_segments, :trip_id, :integer
    say "done!"
  end

  def self.down
    remove_column :trip_segments, :trip_id
  end
end