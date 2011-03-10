class ChangeColumnName < ActiveRecord::Migration
  def self.up
    rename_column :trip_segments, :origin_id, :locale_origin_id
    rename_column :trip_segments, :destination_id, :locale_destination_id
  end

  def self.down
  end
end
