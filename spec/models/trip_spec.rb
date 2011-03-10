require 'spec_helper'

describe Trip do

  context "validations" do
    it "should require a name" do
      Trip.new.should_not be_valid
    end
  end

  context "super_chained_join_scope" do
    it "should return the trip name and segment name, ordered by trip name, 10 segments, with segments included, where trip < today" do
      10.times do |t|
        trip = Trip.create!(:name => "Hong Kong - "+t.to_s)
        3.times do |s|
          TripSegment.create!(:name => "Segment-"+s.to_s, :origin => "X", :destination => "Y", :distance_in_miles => 1000, :trip_id => trip.id, :start_date => Time.now - 1.day)
        end
      end

      # SELECT  trips.name, trip_segments.name FROM \"trips\"
      # INNER JOIN \"trip_segments\" ON \"trip_segments\".\"trip_id\" = \"trips\".\"id\"
      # WHERE (trip_segments.start_date < '2011-03-11 16:54:25.796449')
      # ORDER BY trips.name DESC LIMIT 10
      p Trip.super_chained_join_scope.to_sql
      Trip.super_chained_join_scope.count.should == 5   # <<<< Returns 30; test is failing; limit not working? Need to figure out why.
    end
  end

  context "super_chained_include_scope" do
    it "should do eager loading, not n+1 problem" do
      10.times do |t|
         trip = Trip.create!(:name => "Hong Kong - "+t.to_s)
         3.times do |s|
           TripSegment.create!(:name => "Segment-"+s.to_s, :origin => "X", :destination => "Y", :distance_in_miles => 1000, :trip_id => trip.id, :start_date => Time.now - 1.day)
         end
       end
       p Trip.super_chained_include_scope.to_sql
       Trip.super_chained_include_scope.count.should == 5
    end
  end

  context "association to segments" do
    it "should reflect the association" do
       Trip.reflect_on_association(:trip_segments).should_not be_nil
    end

    it "should have trip segments" do
      trip_segment1 = stub_model(TripSegment)
      trip_segment2 = stub_model(TripSegment)

      trip = Trip.create(:name => "My First Trip")
      trip.trip_segments << trip_segment1
      trip.trip_segments << trip_segment2
      trip.should have(2).trip_segments
    end
  end

  context "total_miles" do
    it "should add up all the miles from all the trip segments for the trip" do
      trip_to_be_totaled = Trip.create!(:name => "Totaled Trip")
      other_trip = Trip.create!(:name => "Other Trip")
      total_miles = 0

      10.times do
        miles = rand(3000)+1000
        TripSegment.create!(:origin => "X", :destination => "Y", :distance_in_miles => miles, :trip_id => trip_to_be_totaled.id)
        total_miles += miles
      end
      TripSegment.create!(:origin => "X", :destination => "Y", :distance_in_miles => 10000, :trip_id => other_trip.id)

      trip_to_be_totaled.total_miles.should == total_miles
    end
  end

  context "longest_segment_of_trip" do
    it "should return the segment with longest distance for this trip" do
      this_trip = Trip.create!(:name => "This Trip")
      other_trip = Trip.create!(:name => "Other Trip")
      max_miles = 0

      10.times do
        seg = TripSegment.create!(:origin => "X", :destination => "Y", :distance_in_miles => rand(3000)+1000, :trip_id => this_trip.id)
        if seg.distance_in_miles > max_miles   # <<< is there a more ruby-clever way of doing this?
          @longest_segment = seg
          max_miles = seg.distance_in_miles
        end
      end
      TripSegment.create!(:origin => "X", :destination => "Y", :distance_in_miles => 10000000, :trip_id => other_trip.id)

      this_trip.longest_segment_of_trip.should == @longest_segment
    end
  end
end