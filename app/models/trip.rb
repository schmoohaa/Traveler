class Trip < ActiveRecord::Base
  validates :name, :presence => true    # Rails3 slightly different validation syntax

  has_many :trip_segments

  scope :hong_kong, where("trips.name LIKE ?", "%Hong Kong%")

  # trip name and segment name, ordered by trip name, of 5 trips, with segments joined, where trip < today
  scope :super_chained_join_scope, joins(:trip_segments).select("trips.name tname, trip_segments.name sname").order("trips.name DESC").where("trip_segments.start_date < ?", Time.now + 1.day).hong_kong.limit(5)

  scope :super_chained_include_scope, includes(:trip_segments).select("trips.name tname, trip_segments.name sname").order("trips.name DESC").where("trip_segments.start_date < ?", Time.now + 1.day).hong_kong.limit(5)

  def total_miles
    trip_segments.sum("distance_in_miles")
  end

  def longest_segment_of_trip
    trip_segments.order("distance_in_miles").last  # <<< does limit 1 under the covers
  end
end



# class Book < ActiveRecord::Base
#     validates :title, :presence => true # Always run
#     validates :proofread, :inclusion => {  :in => [true, false] }, :on => :publish # Skipped on create or update
#
#     def publish!
#       # Note the ":publish" argument on #valid? -- we're telling the model to run validations for the ":publish" context
#       valid?(:publish) && toggle(:published) && save!
#     end
#   end