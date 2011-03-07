class RemoveDefaultFromDistanceTraveled < ActiveRecord::Migration
  def self.up
    change_column :trip_segments, :distance_in_miles, :integer
  end

  def self.down
    change_column :trip_segments, :distance_in_miles, :integer, :default => 0
  end
end
