require 'spec_helper'

describe Trip do

  context "validations" do
    it "should require a name" do
      Trip.new.should_not be_valid
    end
  end

  context "association to segments" do
    it "should reflect the association" do
       Trip.reflect_on_association(:trip_segments).should_not be_nil
    end

    it "should have trip segments" do
      @trip_segment1 = stub_model(TripSegment)
      @trip_segment2 = stub_model(TripSegment)

      trip = Trip.create(:name => "My First Trip")
      trip.trip_segments << @trip_segment1
      trip.trip_segments << @trip_segment2
      trip.should have(2).trip_segments
    end
  end
end