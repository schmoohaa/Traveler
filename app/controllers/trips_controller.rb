class TripsController < ApplicationController

  def index
  end

  def index_all
    # want to implement a simple use of include or join.
    @trips = Trip.super_chained_join_scope
    @eager_trips = Trip.super_chained_include_scope
  end

  def new
  end

  def show
    @trip = Trip.find(params[:id])
  end

  def create
    @trip = Trip.new(params[:trip])
    if @trip.save
     redirect_to trip_path(@trip)
    else
     render :new
    end
  end
end