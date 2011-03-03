class CreateTripSegments < ActiveRecord::Migration
  def self.up
    create_table :trip_segments do |t|
      t.string  :name
      t.string :origin
      t.string :destination
      t.datetime :start_date
      t.datetime :end_date
      t.string :mode_of_transport
      t.timestamps
    end
  end

  def self.down
    drop_table :trip_segments
  end
end