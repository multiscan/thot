require "minitest_helper"

describe ApplicationHelper do
  it "convert interval in days to string" do
    days_ago(0).must_equal "today"
    days_ago(1).must_equal "yesterday"
    days_ago(4).must_equal "4 days ago"
    days_ago(7).must_equal "1 weeks ago"
    days_ago(21).must_equal "3 weeks ago"
    days_ago(33).must_equal "more than 4 weeks ago"
    days_ago(84).must_equal "more than 2 months ago"
    true
  end
end
# require 'test_helper'
# class ApplicationHelperTest < ActionView::TestCase
#   tests ApplicationHelper
#   # ...
# end
