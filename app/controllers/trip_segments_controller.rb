class TripSegmentsController < ApplicationController

  def index
  end

  def index_by_trip
    @trip = Trip.find(params[:trip_id])   # <<<< "find" the call is made immediately; not relation lazy loading.
  end

  def index_ordered_by_origin
    @trip_segments = TripSegment.order("origin")  # Rails3 new method for ordering

    # Add another query here it see how a returned Arel "relation" works.
    # Should not produce a query in the log because it is never really used.
    # In log: Trip Load (0.2ms)  SELECT "trips".* FROM "trips" WHERE (name LIKE '%Hong Kong%')
    # when explicitly attempted to be displayed. No logged query otherwise.

    @hong_kong_trips_lazy = Trip.hong_kong   # Lazy
    @hong_kong_trips_now = Trip.hong_kong.all  # Now - query executes immmediately.

  end

  def show
    # @trip_segment = TripSegment.where(:id => params[:id])     <== returns an array, not a single occurence. not correct.
    @trip_segment = TripSegment.find(params[:id])
  end

  def edit
    @trip_segment = TripSegment.find(params[:id])
  end

  def new
  end

  def update
    @trip_segment = TripSegment.find(params[:id])
    if @trip_segment.update_attributes(params[:trip_segment])
      redirect_to trip_segments_path
    else
      render :edit
    end

  end

  def create
    org_location = Locale.location(params[:origin])
    org_location = Locale.create!(:name => params[:origin]) if org_location.empty?
    dest_location = Locale.location(params[:destination])
    dest_location = Locale.create!(:name => params[:destination]) if dest_location.empty?

    @trip_segment = TripSegment.new(params[:trip_segment].merge({:locale_origin_id => org_location.id, :locale_destination_id => dest_location.id} ))
    if @trip_segment.save
      redirect_to trip_segments_path
    else
      render :new
    end
  end

  def limit_by_destination
    @trip_segments = TripSegment.destination(params[:destination])  # Rails3 use of scope method
  end

  def order_by_distance
    @destination = params[:destination]
    @trip_segments = TripSegment.order_by_miles_to_destination(@destination)  # Rails3 use of scope method that reuses another scope.
  end

  def destroy
    @destroyed_trip_segment = params[:id]
    TripSegment.find(@destroyed_trip_segment).delete
  end

  def search
    @locale = params[:locale]
    @trip_segments = TripSegment.search(@locale )

    render "searched_segments"
  end
end