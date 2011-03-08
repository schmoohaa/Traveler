require 'spec_helper'

describe TripsController do
  context "index" do
    it "should return succesfully" do
      get :index
      response.should be_success
    end
  end

  context "new" do
    it "should return successfully" do
      get :new
      response.should be_success
    end
  end

  context "show" do
    it "should return successfully" do
      @trip = stub_model(Trip)
      Trip.stub!(:find).and_return(@trip)

      get :show, :id => @trip
      response.should be_success
    end
    it "should assign trip" do
      @trip = stub_model(Trip)
      Trip.stub!(:find).and_return(@trip)

      get :show, :id => @trip
      assigns(:trip).should == @trip
    end
  end

  context "create" do
    it "return to show after successful creation" do
      @trip = stub_model(Trip)
      Trip.stub!(:new).and_return(@trip)
      @trip.stub!(:save).and_return(true)

      post :create, :name => "test trip"
      response.should redirect_to(trip_path(@trip))
    end
    it "should return to :new if error" do
      @trip = stub_model(Trip)
      Trip.stub!(:new).and_return(@trip)
      @trip.stub!(:save).and_return(false)

      post :create, :name => "test trip"
      response.should render_template(:new)
    end
  end
end