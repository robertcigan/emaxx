require "spec_helper"

describe PhotosController do
  describe "routing" do

    it "routes to #create" do
      post("/pages/1/photos").should route_to("photos#create", :page_id => "1")
    end

    it "routes to #destroy" do
      delete("/pages/1/photos/1").should route_to("photos#destroy", :id => "1", :page_id => "1")
    end

  end
end
