require 'spec_helper'

describe TripSegmentsController do

  before(:each) do
    @distance_traveled = rand(6000)+1000
  end

  context "index" do
    it "should return succesfully" do
      get :index
      response.should be_success
    end
    it "should return trip segments" do
      # TripSegment.create!(:origin=>"sin",:destination=>"dbx",:start_date=>Time.now)
      # TripSegment.create!(:name=>"RTW Trip: seg 1",:origin=>"ord",:destination=>"hkg",:start_date=>Time.now)
      # TripSegment.create!(:origin=>"hkg",:destination=>"sin",:start_date=>Time.now)
      #
      # get :index

      # WHAT DO I TEST FOR GIVEN THE VIEW CONTAINS THE CALL? IS THIS RIGHT? DONE FOR CACHEING POSSIBILITIES.


    end
  end

  context "index_by_trip" do
    before(:each) do
      @trip = stub_model(Trip)
      Trip.stub!(:find).and_return(@trip)
    end
    it "should return successfully" do
      get :index_by_trip, :trip_id => @trip.id
      response.should be_success
    end
    it "should assign segments" do
      @trip_seg1 = stub_model(TripSegment, :trip_id => @trip.id)
      @trip_seg2 = stub_model(TripSegment, :trip_id => @trip.id)

      get :index_by_trip, :trip_id => @trip.id

      assigns(:trip).should == @trip
    end
  end

  context "show" do
    before(:each) do
      @trip_segment = stub_model(TripSegment)
      TripSegment.stub!(:find).and_return(@trip_segment)
    end

    it "should return successfully" do
      get :show, :id => @trip_segment
      response.should be_success
    end
    it "should contain a trip_segment" do
      get :show, :id => @trip_segment
      assigns(:trip_segment).should == @trip_segment
    end
  end

  context "new" do
    it "should return new trip segment form successfully" do
      get :new
      response.should be_success
    end
  end

  context "edit" do
    before(:each) do
      @trip_segment = stub_model(TripSegment)
      TripSegment.stub!(:find).and_return(@trip_segment)
    end

    it "should return edit form successfully" do
      get :edit, :id => @trip_segment
      response.should be_success
    end
    it "should show correct trip" do
      get :edit, :id => @trip_segment
      assigns(:trip_segment).should == @trip_segment
    end
  end

  context "update" do
    before(:each) do
      @trip_segment = stub_model(TripSegment)
      TripSegment.stub!(:find).and_return(@trip_segment)
    end

    it "should update trip and redirect to index successfully" do
      @trip_segment.stub!(:update_attributes).and_return(true)

      put :update, :id => @trip_segment, :distance_in_miles => 100000
      response.should redirect_to(trip_segments_path)
    end
    it "should return edit form if error when updating" do
      @trip_segment.stub!(:update_attributes).and_return(false)

      put :update, :id => @trip_segment, :trip_segment => {:distance_in_miles => nil}
      response.should render_template(:edit)
    end
  end

  context "create" do
    it "should respond successfully with index page" do
      do_post_new_trip
      response.should redirect_to(trip_segments_path)
    end
    it "should create add new trip_segment" do
      expect { do_post_new_trip }.to change(TripSegment, :count).by(1)
    end
    it "should not create a new trip if errors" do
      expect { do_post_new_trip(:trip_segment => {:origin => nil} ) }.to change(TripSegment, :count).by(0)
    end
    it "should return to form if errors" do
      do_post_new_trip(:trip_segment => {:origin => nil} )
      response.should render_template(:new)
    end

    def do_post_new_trip(params={})
      post :create, {
        :trip_segment => {
            :name       => 'Best Trip Ever!',
            :origin => 'Chicago, Illinois',
            :destination => 'Singapore, Singapore',
            :start_date => Time.now,
            :end_date => Time.new + 5.days,
            :distance_in_miles => @distance_traveled
          }
        }.update(params)
    end
  end

  context "index_ordered_by_origin" do
    it "should render 200" do
      xhr :get, :index_ordered_by_origin
      response.should be_success
    end
    it "should list trip segments in order" do
      trip1 = TripSegment.create!(:origin=>"sin",:destination=>"dbx",:start_date=>Time.now, :distance_in_miles => @distance_traveled)
      trip2 = TripSegment.create!(:name=>"RTW Trip: seg 1",:origin=>"ord",:destination=>"hkg",:start_date=>Time.now, :distance_in_miles => @distance_traveled)
      trip3 = TripSegment.create!(:origin=>"hkg",:destination=>"sin",:start_date=>Time.now, :distance_in_miles => @distance_traveled)

      xhr :get, :index_ordered_by_origin

      assigns(:trip_segments).first.should == trip3
      assigns(:trip_segments).last.should == trip1
      assigns(:trip_segments).count.should == 3
    end
  end

  context "limit_by_destination" do
    it "should render 200" do
       xhr :get, :limit_by_destination, :destination => "Dubai, UAE"
       response.should be_success
    end
    it "should return content with some trips visible, others not" do
      trip1 = TripSegment.create!(:origin=>"Chicago",:destination=>"Dubai, UAE",:start_date=>Time.now, :distance_in_miles => @distance_traveled)
      trip2 = TripSegment.create!(:name=>"RTW Trip: seg 1",:origin=>"Chicago",:destination=>"Tokyo, Japan",:start_date=>Time.now, :distance_in_miles => @distance_traveled)
      trip3 = TripSegment.create!(:origin=>"Paris, France",:destination=>"Prague, Czech Republic",:start_date=>Time.now, :distance_in_miles => @distance_traveled)
      trip4 = TripSegment.create!(:origin=>"Istanbul, Turkey",:destination=>"Dubai, UAE",:start_date=>Time.now, :distance_in_miles => @distance_traveled)
      trip5 = TripSegment.create!(:origin=>"Dubai, UAE",:destination=>"London, Heathrow",:start_date=>Time.now, :distance_in_miles => @distance_traveled)

      xhr :get, :limit_by_destination, :destination => "Dubai, UAE"

      assigns(:trip_segments).should include(trip1,trip4)
      assigns(:trip_segments).should_not include(trip2,trip3,trip5)
    end
  end

  context "delete trip segment" do
    it "should  return 200" do
      @deleted_trip = stub_model(TripSegment)
      TripSegment.stub!(:find).and_return(@deleted_trip)
      TripSegment.stub!(:delete).and_return(true)

      xhr :delete, :destroy, :id => @deleted_trip.id
      response.should be_success
    end
  end

  context "search" do
    it "should return successfully" do
      @search_locale = "Hong Kong"
      @searched_trip = stub_model(TripSegment, :origin => @search_locale)
      TripSegment.stub!(:search).and_return(@searched_trip)

      xhr :get, :search, :locale => @search_locale

      assigns(:trip_segments).should == @searched_trip
      assigns(:locale).should == @search_locale
      response.should be_success
    end
  end

  # context "order_by_distance" do
  #   it "should render 200" do
  #     xhr :get, :order_by_distance, :destination => "Dubai, UAE"
  #
  #     # xhr :get, :order_by_distance_destination, :destination => "Dubai, UAE"
  #     # xhr :get, :new, :organization_id => @org.id
  #     # response.should be_success
  #   end
  # end
end