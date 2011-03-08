class TripSegment < ActiveRecord::Base

  belongs_to :trip

  validates :origin, :destination, :distance_in_miles, :presence => true    # Rails3 slightly different validation syntax
  validate :validation_origin_destination
  validates :distance_in_miles, :numericality => {:greater_than => 100}
  validates_datetime :start_date, :allow_nil => true
  validates_datetime :end_date, :allow_nil => true

  after_validation :generate_trip_segment_name, :unless => :name?

  scope :destination, lambda { |dest| where("destination = ?", dest)}     # Rails3 scope
  scope :order_by_miles_to_destination, lambda { |dest| destination(dest).order("distance_in_miles DESC") }    # Rails3 scoper....reusing another scope in sort of a contrived way.

  def validation_origin_destination
    errors.add(:base,"Origin and Destination must be different") if origin == destination    # Rails3 slightly different?
  end

  def generate_trip_segment_name
    self.name = "#{origin} - #{destination}"
  end
end