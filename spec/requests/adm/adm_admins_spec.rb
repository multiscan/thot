require 'spec_helper'

describe "Adm::Admins" do
  describe "GET /adm_admins" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get adm_admins_path
      response.status.should be(200)
    end
  end
end
