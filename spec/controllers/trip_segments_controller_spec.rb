require 'spec_helper'

describe TripSegmentsController do

  context "index" do
    it "should return succesfully" do
      get :index
      response.should be_success
    end
  end


  context "show" do
    it "should return successfully" do

    end
    it "should contain trip_segment" do

    end
  end

  context "new" do
    it "should return new trip segment form successfully" do
      get :new
      response.should be_success
    end
  end

  context "create" do
    it "should " do

    end
    it "should return to index if successful" do

    end
    it "should return to form if errors" do

    end
  end
end