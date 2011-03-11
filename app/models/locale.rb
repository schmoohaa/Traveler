class Locale < ActiveRecord::Base

  geocoded_by :name, :latitude  => :lat, :longitude => :lng
  after_validation :geocode

  validates :name, :uniqueness => true

  scope :location, lambda { |loc| where("name = ?", loc)}

  def to_s
    name
  end
end
