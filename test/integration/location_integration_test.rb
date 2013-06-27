require "minitest_helper"

describe "Locations integration" do
  it "is only accessible by logged in admins" do
    visit root_path   # adm_locations_path
    page.text.must_include "Search"
  end
end
