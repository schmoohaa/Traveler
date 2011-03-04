class TripSegmentsController < ApplicationController

  def index
  end

  def index_ordered_by_origin
    @trip_segments = TripSegment.order("origin")  # new method for ordering
  end

  def show
    # @trip_segment = TripSegment.where(:id => params[:id])     <== returns an array, not a single occurance. not correct.
    @trip_segment = TripSegment.find(params[:id])
  end

  def new
  end

  def create
    @trip_segment = TripSegment.new(params[:trip_segment])
    if @trip_segment.save
      redirect_to trip_segments_path
    else
      render :new
    end
  end

  def limit_by_destination
    @trip_segments = TripSegment.destination(params[:destination])
  end
end