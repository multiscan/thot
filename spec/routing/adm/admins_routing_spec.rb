require "spec_helper"

describe Adm::AdminsController do
  describe "routing" do

    it "routes to #index" do
      get("/adm/admins").should route_to("adm/admins#index")
    end

    it "routes to #new" do
      get("/adm/admins/new").should route_to("adm/admins#new")
    end

    it "routes to #show" do
      get("/adm/admins/1").should route_to("adm/admins#show", :id => "1")
    end

    it "routes to #edit" do
      get("/adm/admins/1/edit").should route_to("adm/admins#edit", :id => "1")
    end

    it "routes to #create" do
      post("/adm/admins").should route_to("adm/admins#create")
    end

    it "routes to #update" do
      put("/adm/admins/1").should route_to("adm/admins#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/adm/admins/1").should route_to("adm/admins#destroy", :id => "1")
    end

  end
end
