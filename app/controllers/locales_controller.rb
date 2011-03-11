class LocalesController < ApplicationController

  def show
    @locale = Locale.find(params[:id])
  end

  def show_segment_locales
    @locales = [Locale.location(params[:origin]).first,Locale.location(params[:destination]).first]
    render "show_locales"
  end

  def show_trip_locales
    @locales = []
    trip = Trip.find(params[:trip_id])
    trip.trip_segments.each do |seg|
      @locales << seg.locale_origin
      @locales << seg.locale_destination
    end
    render "show_locales"
  end
end