class AddDistanceTraveled < ActiveRecord::Migration
  def self.up
    add_column :trip_segments, :distance_in_miles, :integer, :default => 0
  end

  def self.down
    remove_column :trip_segments, :distance_in_miles
  end
end
