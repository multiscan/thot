require "minitest_helper"

# class LocationTest < MiniTest::Unit::TestCase
#   def test_to_param
#     location = Location.create!(name: "INR 120")
#     assert_equal "#{location.id}", location.to_param
#   end
# end

describe Location do
  it "have standard to_param" do
    location = Location.create!(name: "INR 120")
    location.to_param.must_equal "#{location.id}"
  end
end
