require 'spec_helper'

describe TripSegment do
  before(:each) do
    @origin = "Chicago, Illinois"
    @destination = "Hong Kong, Hong Kong"
    @other_destination = "Kathmandu, Nepal"
    @valid_start_date = DateTime.new(2008, 9, 11, 11, 55, 0, 0)
    @valid_end_date = DateTime.new(2008, 9, 12, 17, 55, 0, 0)
    @distance_traveled = rand(6000)+1000

    @trip = stub_model(Trip)
  end
  context "validations" do
    it "should require an origin" do
      TripSegment.new.should_not be_valid
    end
    it "should require a destination" do
      TripSegment.new(:origin => @origin, :destination => @destination, :distance_in_miles => @distance_traveled, :trip_id => @trip.id).should be_valid
    end
    it "should prevent origin and destination from being the same" do
      TripSegment.new(:origin => @origin, :destination => @origin, :distance_in_miles => @distance_traveled).should_not be_valid
      TripSegment.new(:origin => @origin, :destination => @destination, :distance_in_miles => @distance_traveled, :trip_id => @trip.id).should be_valid
    end
    it "should require valid start date" do
      TripSegment.new(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id).should be_valid
    end
    it "should require valid end date" do
      TripSegment.new(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id).should be_valid
    end
    it "should require mileage for any trip segment" do
       TripSegment.new(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :trip_id => @trip.id).should_not be_valid
     end
    it "should require distance to be numeric" do
      TripSegment.new(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => "I went 10,000 miles!", :trip_id => @trip.id).should_not be_valid
    end
    it "should require distance to be greater than 100" do
      TripSegment.new(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 50, :trip_id => @trip.id).should_not be_valid
    end
    it "should require that the segment be associated with a trip" do
      TripSegment.new(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 1000, :trip_id => @trip.id).should be_valid
    end
  end

  context "adding trips" do
    it "should add a trip" do
      trip = TripSegment.create(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)
      trip.save!.should be_true
    end
    it "should auto-generate name to concatenated origin-dest if not entered" do
      trip = TripSegment.create(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)
      trip.name.should == "#{@origin} - #{@destination}"
    end
    it "should set name to what was entered (not auto-generate)" do
      trip = TripSegment.create(:name => "My Hong Kong Trip",:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)
      trip.name.should_not == "#{@origin} - #{@destination}"
    end
  end

  context "scope on destination" do
    it "should return a relation of segments of destination value" do
      TripSegment.create(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)
      TripSegment.create(:origin => @origin, :destination => @other_destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)

      TripSegment.destination(@destination).count.should == 1
    end
  end
  context "scope: miles to destination" do
    it "should return a relation of specified destination in distance order" do
      @other_origin1 = "San Francisco, California"
      @other_origin2 = "Los Angeles, California"
      @other_origin3 = "Tokyo, Japan"
      @other_origin4 = "Singapore, Singapore"
      @other_origin5 = "Bangkok, Thailand"

      ord2hkg = TripSegment.create(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 7400, :trip_id => @trip.id)
      sfo2hkg = TripSegment.create(:origin => @other_origin1, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 7100, :trip_id => @trip.id)
      lax2hkg = TripSegment.create(:origin => @other_origin2, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 7300, :trip_id => @trip.id)
      sin2hkg = TripSegment.create(:origin => @other_origin4, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 1500, :trip_id => @trip.id)
      bkk2hkg = TripSegment.create(:origin => @other_origin5, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 900, :trip_id => @trip.id)
      nrt2hkg = TripSegment.create(:origin => @other_origin3, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 2000, :trip_id => @trip.id)

      TripSegment.order_by_miles_to_destination(@destination)[0].should == ord2hkg
      TripSegment.order_by_miles_to_destination(@destination)[3].should == nrt2hkg
      TripSegment.order_by_miles_to_destination(@destination)[5].should == bkk2hkg
    end
  end

  context "association" do
    it "should reflect the association" do
       TripSegment.reflect_on_association(:trip).should_not be_nil
    end

    # it "should be part of a trip" do
    #   @trip_segment = stub_model(TripSegment)
    #
    #   @trip_segment.should belong_to(1).trip
    #
    # end
  end
end