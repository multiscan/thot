### GIVEN ###
### WHEN ###

When /^I visit the (\/[^ ]+) page$/ do |path|
  visit path
end

# When /^I visit the events page$/ do
#   visit '/events'
# end

# When /^I visit the my events page$/ do
#   visit '/events/my'
# end

### THEN ###

Then /^I should see the link for adding a new event$/ do
  page.should have_content "New event"
end
