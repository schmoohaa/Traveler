class Locale < ActiveRecord::Base

  geocoded_by :name, :latitude  => :lat, :longitude => :lng
  after_validation :geocode

  def to_s
     name
  end
end
