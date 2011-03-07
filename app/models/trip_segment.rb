class TripSegment < ActiveRecord::Base

  validates :origin, :destination, :distance_in_miles, :presence => true    # Rails3 slightly different validation syntax
  validate :validation_origin_destination
  validates :distance_in_miles, :numericality => {:greater_than => 100}
  validates_datetime :start_date, :allow_nil => true
  validates_datetime :end_date, :allow_nil => true

  after_validation :generate_trip_segment_name, :unless => :name?

  scope :destination, lambda { |dest| where("destination = ?", dest)}     # Rails3 scope

  def validation_origin_destination
    errors.add(:base,"Origin and Destination must be different") if origin == destination    # Rails3 slightly different?
  end

  def generate_trip_segment_name
    self.name = "#{origin} - #{destination}"
  end
end