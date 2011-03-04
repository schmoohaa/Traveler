require 'spec_helper'

describe TripSegment do
  before(:each) do
    @origin = "Chicago, Illinois"
    @destination = "Hong Kong, Hong Kong"
    @other_destination = "Kathmandu, Nepal"
    @valid_start_date = DateTime.new(2008, 9, 11, 11, 55, 0, 0)
    @valid_end_date = DateTime.new(2008, 9, 12, 17, 55, 0, 0)
  end
  context "validations" do
    it "should require an origin" do
      TripSegment.new.should_not be_valid
    end
    it "should require a destination" do
      TripSegment.new(:origin => @origin, :destination => @destination).should be_valid
    end
    it "should prevent origin and destination from being the same" do
      TripSegment.new(:origin => @origin, :destination => @origin).should_not be_valid
      TripSegment.new(:origin => @origin, :destination => @destination).should be_valid
    end
    it "should require valid start date" do
      TripSegment.new(:origin => @origin, :destination => @destination, :start_date => @valid_start_date).should be_valid
    end
    it "should require valid end date" do
      TripSegment.new(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date).should be_valid
    end

  end

  context "adding trips" do
    it "should add a trip" do
      trip = TripSegment.create(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date)
      trip.save!.should be_true
    end
    it "should auto-generate name to concatenated origin-dest if not entered" do
      trip = TripSegment.create(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date)
      trip.name.should == "#{@origin} - #{@destination}"
    end
    it "should set name to what was entered (not auto-generate)" do
      trip = TripSegment.create(:name => "My Hong Kong Trip",:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date)
      trip.name.should_not == "#{@origin} - #{@destination}"
    end
  end

  context "scope on destination" do
    it "should return a relation of segments of destination value" do
      TripSegment.create(:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date)
      TripSegment.create(:origin => @origin, :destination => @other_destination, :start_date => @valid_start_date, :end_date => @valid_end_date)

      TripSegment.destination(@destination).count.should == 1
    end
  end
end