require 'spec_helper'

describe "PublisherMergers" do
  describe "GET /publisher_mergers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get publisher_mergers_path
      response.status.should be(200)
    end
  end
end
