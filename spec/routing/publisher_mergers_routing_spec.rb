require "spec_helper"

describe PublisherMergersController do
  describe "routing" do

    it "routes to #index" do
      get("/publisher_mergers").should route_to("publisher_mergers#index")
    end

    it "routes to #new" do
      get("/publisher_mergers/new").should route_to("publisher_mergers#new")
    end

    it "routes to #show" do
      get("/publisher_mergers/1").should route_to("publisher_mergers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/publisher_mergers/1/edit").should route_to("publisher_mergers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/publisher_mergers").should route_to("publisher_mergers#create")
    end

    it "routes to #update" do
      put("/publisher_mergers/1").should route_to("publisher_mergers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/publisher_mergers/1").should route_to("publisher_mergers#destroy", :id => "1")
    end

  end
end
