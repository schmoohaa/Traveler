class Locale < ActiveRecord::Base

  geocoded_by :name, :latitude  => :lat, :longitude => :lng
  before_save :geocode, :if => :in_dev?

  validates :name, :uniqueness => true

  scope :location, lambda { |loc| where("name = ?", loc)}

  def to_s
    name
  end

  def in_dev?
    false
    # Rails.env.development? # <<< lame, but could not figure out how to tell gem not to call google in test.
  end
end
