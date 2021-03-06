require 'spec_helper'

describe TripSegment do
  before(:each) do
    @trip = stub_model(Trip)

    @origin = stub_model(Locale, :name => "Chicago, Illinois")
    @destination = stub_model(Locale, :name => "Hong Kong, Hong Kong")
    @other_destination = stub_model(Locale, :name => "Kathmandu, Nepal")

    TripSegment.stub!(:locale_origin).and_return(@origin)
    TripSegment.stub!(:locale_destination).and_return(@destination)

    @other_destination = "Kathmandu, Nepal"
    @valid_start_date = DateTime.new(2008, 9, 11, 11, 55, 0, 0)
    @valid_end_date = DateTime.new(2008, 9, 12, 17, 55, 0, 0)
    @distance_traveled = rand(6000)+1000
  end
  context "validations" do
    it "should require an origin" do

      TripSegment.new.should_not be_valid
    end
    it "should require a destination" do
      TripSegment.new(:locale_origin_id => @origin.id, :locale_destination_id => @destination.id, :distance_in_miles => @distance_traveled, :trip_id => @trip.id).should be_valid
    end
    it "should prevent origin and destination from being the same" do
      TripSegment.new(:locale_origin_id => @origin.id, :locale_destination_id => @origin.id, :distance_in_miles => @distance_traveled).should_not be_valid
      TripSegment.new(:locale_origin_id => @origin.id, :locale_destination_id => @other_destination.id, :distance_in_miles => @distance_traveled, :trip_id => @trip.id).should be_valid
    end
    it "should require valid start date" do
      TripSegment.new(:locale_origin_id => @origin.id, :locale_destination_id => @destination.id, :start_date => @valid_start_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id).should be_valid
    end
    it "should require valid end date" do
      TripSegment.new(:locale_origin_id => @origin.id, :locale_destination_id => @destination.id, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id).should be_valid
    end
    it "should require mileage for any trip segment" do
       TripSegment.new(:locale_origin_id => @origin.id, :locale_destination_id => @destination.id, :start_date => @valid_start_date, :end_date => @valid_end_date, :trip_id => @trip.id).should_not be_valid
     end
    it "should require distance to be numeric" do
      TripSegment.new(:locale_origin_id => @origin.id, :locale_destination_id => @destination.id, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => "I went 10,000 miles!", :trip_id => @trip.id).should_not be_valid
    end
    it "should require distance to be greater than 100" do
      TripSegment.new(:locale_origin_id => @origin.id, :locale_destination_id => @destination.id, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 50, :trip_id => @trip.id).should_not be_valid
    end
    it "should require that the segment be associated with a trip" do
      TripSegment.new(:locale_origin_id => @origin.id, :locale_destination_id => @destination.id, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 1000, :trip_id => @trip.id).should be_valid
    end
  end

  context "adding trips" do
    it "should add a trip" do

      trip = TripSegment.create(:locale_origin_id => @origin.id, :locale_destination_id => @destination.id, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)
      trip.save!.should be_true
    end
    # it "should auto-generate name to concatenated origin-dest if not entered" do
    #   trip = TripSegment.create(:locale_origin_id => @origin_id, :locale_destination_id => @destination_id, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)
    #   trip.name.should == "#{@origin} - #{@destination}"
    # end
    # it "should set name to what was entered (not auto-generate)" do
    #   trip = TripSegment.create(:name => "My Hong Kong Trip",:origin => @origin, :destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)
    #   trip.name.should_not == "#{@origin} - #{@destination}"
    # end
  end

  context "scope on destination" do
    it "should return a relation of segments of destination value" do
      @real_origin = Locale.create!(:name => "Chicago")
      @real_destination = Locale.create!(:name => "Hong Kong")
      @other_real_destination = Locale.create!(:name => "Kathmandu, Nepal")

      TripSegment.create(:locale_origin_id => @real_origin.id, :locale_destination_id => @real_destination.id, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)
      TripSegment.create(:locale_origin_id => @real_origin.id, :locale_destination_id => @other_real_destination.id, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => @distance_traveled, :trip_id => @trip.id)

      TripSegment.destination(@real_destination.name).count.should == 1
    end
  end
  context "scope: miles to destination" do
    it "should return a relation of specified destination in distance order" do
      @destination = Locale.create!(:name => "Hong Kong, Hong Kong")

      @other_origin1 = Locale.create!(:name => "San Francisco, California")
      @other_origin2 = Locale.create!(:name => "Los Angeles, California")
      @other_origin3 = Locale.create!(:name => "Tokyo, Japan")
      @other_origin4 = Locale.create!(:name => "Singapore, Singapore")
      @other_origin5 = Locale.create!(:name => "Bangkok, Thailand")

      ord2hkg = TripSegment.create(:locale_origin => @origin, :locale_destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 7400, :trip_id => @trip.id)
      sfo2hkg = TripSegment.create(:locale_origin => @other_origin1, :locale_destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 7100, :trip_id => @trip.id)
      lax2hkg = TripSegment.create(:locale_origin => @other_origin2, :locale_destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 7300, :trip_id => @trip.id)
      sin2hkg = TripSegment.create(:locale_origin => @other_origin4, :locale_destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 1500, :trip_id => @trip.id)
      bkk2hkg = TripSegment.create(:locale_origin => @other_origin5, :locale_destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 900, :trip_id => @trip.id)
      nrt2hkg = TripSegment.create(:locale_origin => @other_origin3, :locale_destination => @destination, :start_date => @valid_start_date, :end_date => @valid_end_date, :distance_in_miles => 2000, :trip_id => @trip.id)

      TripSegment.order_by_miles_to_destination(@destination.name)[0].should == ord2hkg
      TripSegment.order_by_miles_to_destination(@destination.name)[3].should == nrt2hkg
      TripSegment.order_by_miles_to_destination(@destination.name)[5].should == bkk2hkg
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

  context "longest_segment" do
    it "should return longest segment of all trips" do
      trips = []
      5.times  {|i| trips << Trip.create!(:name => i.to_s)}
      max_miles = 0

      10.times do
        seg = TripSegment.create!(:locale_origin_id => 1, :locale_destination_id => 2, :distance_in_miles => rand(3000)+1000, :trip_id => trips[rand(trips.length-1)].id)
        @longest_segment = seg            if seg.distance_in_miles > max_miles   # <<< better way?
        max_miles = seg.distance_in_miles if seg.distance_in_miles > max_miles
      end

      TripSegment.longest_segment.should == @longest_segment
    end
    # it "should return nothing if no segments exists" do
    #   TripSegment.longest_segment.should == ""
    # end
  end

  # context "search" do
  #   # trying to implement dynamic scopes across multiple fields
  #   it "should return trip segments with origin or destination of the search token" do
  #     @trip = Trip.create!(:name => "RTW")
  #     @locale_to_search = Locale.create!(:name => "Hong Kong")
  #     @other_locales = []
  #     ["Chicago","Bangkok","Prague","St.Petersburg","Copenhagen","Tokyo","Shanghai","Paris","Dubai","Singapore","Seoul", "Macua", "Las Vegas"].each do |loc|
  #       @other_locales << Locale.create!(:name => loc)
  #     end
  #
  #     10.times do
  #       TripSegment.create!(:locale_origin_id => @other_locales[rand(@other_locales.length-1)].id, :locale_destination_id => @other_locales[rand(@other_locales.length-1)].id, :distance_in_miles => rand(3000)+1000, :trip_id => @trip.id)
  #     end
  #
  #     orginArr = [3,5,7]
  #     destArr = [2,6,10]
  #     orginArr.each do |i|
  #       seg = TripSegment.find(i)
  #       seg.locale_origin_id=(@locale_to_search.id)
  #       seg.save!
  #     end
  #     destArr.each do |i|
  #       seg = TripSegment.find(i)
  #       seg.locale_destination_id=(@locale_to_search.id)
  #       seg.save!
  #      end
  #
  #     TripSegment.search(@locale_to_search).size.should == (destArr.size + orginArr.size)
  #   end
  # end
end