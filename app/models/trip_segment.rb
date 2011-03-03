class TripSegment < ActiveRecord::Base

  validates :origin, :destination, :presence => true
  validate :validation_origin_destination

  validates_datetime :start_date, :allow_nil => true
  validates_datetime :end_date, :allow_nil => true

  after_validation :generate_trip_segment_name, :unless => :name?

  def validation_origin_destination
    errors.add(:base,"Origin and Destination must be different") if origin == destination
  end

  def generate_trip_segment_name
    self.name = "#{origin} - #{destination}"
  end
end