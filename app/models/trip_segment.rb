class TripSegment < ActiveRecord::Base

  belongs_to :trip

  belongs_to :locale_origin, :class_name => "Locale"
  belongs_to :locale_destination, :class_name => "Locale"

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

  def self.longest_segment
    order("distance_in_miles").last   # <<< could'vd done a scope. now that I think about it.
  end

  class << self
    def search(q)
      query = "%#{q}%"
      where("trip_segments.origin LIKE ? OR trip_segments.destination LIKE ?", query,query)
    end

    # dynamic scope construction; not sure it is R3s-specific

    # NOTE: one can NOT chain where clauses with "or"; default is "AND"; only a gem will help.
    # def search(locale)
    #   [:origin, :destination].inject(scoped) do |combined_scope, attr|
    #     combined_scope.where("trip_segments.#{attr} LIKE ?", "%#{locale}%")
    #   end
    # end
  end
end