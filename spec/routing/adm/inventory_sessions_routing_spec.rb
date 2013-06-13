require "spec_helper"

describe Adm::InventorySessionsController do
  describe "routing" do

    it "routes to #index" do
      get("/adm/inventory_sessions").should route_to("adm/inventory_sessions#index")
    end

    it "routes to #new" do
      get("/adm/inventory_sessions/new").should route_to("adm/inventory_sessions#new")
    end

    it "routes to #show" do
      get("/adm/inventory_sessions/1").should route_to("adm/inventory_sessions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/adm/inventory_sessions/1/edit").should route_to("adm/inventory_sessions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/adm/inventory_sessions").should route_to("adm/inventory_sessions#create")
    end

    it "routes to #update" do
      put("/adm/inventory_sessions/1").should route_to("adm/inventory_sessions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/adm/inventory_sessions/1").should route_to("adm/inventory_sessions#destroy", :id => "1")
    end

  end
end
