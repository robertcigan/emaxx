require "spec_helper"

describe SiteController do
  describe "routing" do
    it "routes to #index" do
      get("/").should route_to("site#index")
    end
  end
end
