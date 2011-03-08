class TripsController < ApplicationController

  def index
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