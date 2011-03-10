class CreateLocales < ActiveRecord::Migration
  def self.up
    create_table :locales do |t|
      t.string  :name
      t.decimal :lat, :precision => 10, :scale => 6, :null => true
      t.decimal :lng, :precision => 10, :scale => 6, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :locales
  end
end