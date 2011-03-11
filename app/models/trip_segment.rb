class TripSegment < ActiveRecord::Base

  belongs_to :trip

  belongs_to :locale_origin, :class_name => "Locale"
  belongs_to :locale_destination, :class_name => "Locale"

  validates :locale_origin_id, :locale_destination_id, :distance_in_miles, :presence => true    # Rails3 slightly different validation syntax
  validate :validation_origin_destination
  validates :distance_in_miles, :numericality => {:greater_than => 100}
  validates_datetime :start_date, :allow_nil => true
  validates_datetime :end_date, :allow_nil => true

  # before_save :generate_trip_segment_name, :unless => :name?

  scope :destination, lambda { |dest| where("locales.name = ?", dest).joins(:locale_destination)}     # Rails3 scope
  scope :order_by_miles_to_destination, lambda { |dest| destination(dest).order("trip_segments.distance_in_miles DESC") }    # Rails3 scoper....reusing another scope in sort of a contrived way.

  def validation_origin_destination
    errors.add(:base,"Origin and Destination must be different") if locale_origin_id == locale_destination_id    # Rails3 slightly different?
  end

  #  Could be association is not created when this is called, causing issues.
  # def generate_trip_segment_name
  #   self.name = "#{locale_origin.name} - #{locale_destination.name}"
  # end

  def self.longest_segment
    order("distance_in_miles").last   # <<< could'vd done a scope. now that I think about it.
  end

  # class << self
  #   def search(q)
  #     query = "%#{q}%"
  #     # where("trip_segments.origin LIKE ? OR trip_segments.destination LIKE ?", query,query)
  #
  #     joins(:locale_origin,:locale_destination).where("name like ?", loc)}
  #
  #   end
  #
  #   # dynamic scope construction; not sure it is R3s-specific
  #
  #   # NOTE: one can NOT chain where clauses with "or"; default is "AND"; only a gem will help.
  #   # def search(locale)
  #   #   [:origin, :destination].inject(scoped) do |combined_scope, attr|
  #   #     combined_scope.where("trip_segments.#{attr} LIKE ?", "%#{locale}%")
  #   #   end
  #   # end
  # end
end