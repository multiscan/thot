### UTILITY METHODS ###

def build_visitor(role=:admin)
  @visitor ||= FactoryGirl.attributes_for(role)
end

def find_admin
  @admin ||= Admin.where(:email => @visitor[:email]).first
end

def create_unconfirmed_admin
  build_visitor
  destroy_admin
  sign_up
  visit '/admins/sign_out'
end

def create_admin(role=:operator)
  build_visitor(role)
  destroy_admin
  @admin = FactoryGirl.build(role)
  @admin.confirmed_at = DateTime.now
  @admin.save
end

def destroy_admin
  find_admin
  @admin.destroy unless @admin.nil?
end

def sign_up
  destroy_admin
  visit '/admins/sign_up'
  fill_in "Name", :with => @visitor[:name]
  fill_in "Email", :with => @visitor[:email]
  fill_in "admin_password", :with => @visitor[:password]
  fill_in "admin_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "Sign up"
  find_admin
end

def sign_in
  visit '/admins/sign_in'
  fill_in "Email", :with => @visitor[:email]
  fill_in "Password", :with => @visitor[:password]
  click_button "Sign in"
end

### GIVEN ###
Given /^I am not logged in$/ do
  visit '/admins/sign_out'
end

Given /^I am logged in$/ do
  create_admin
  sign_in
end

Given /^I am logged in as admin$/ do
  create_admin(:admin)
  sign_in
end

Given /^I exist as a admin$/ do
  create_admin
end

Given /^I exist as administrator$/ do
  create_admin(:admin)
end


Given /^I do not exist as a admin$/ do
  build_visitor
  destroy_admin
end

Given /^I exist as an unconfirmed admin$/ do
  create_unconfirmed_admin
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  build_visitor
  sign_in
end

When /^I sign out$/ do
  visit '/admins/sign_out'
end

When /^I sign up with valid admin data$/ do
  build_visitor
  sign_up
end

When /^I sign up with an invalid email$/ do
  build_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up without a password confirmation$/ do
  build_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I sign up without a password$/ do
  build_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  build_visitor
  @visitor = @visitor.merge(:password_confirmation => "please123")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I correctly edit my account details$/ do
  click_link "Edit account"
  fill_in "admin_password", :with => "ciccio"
  fill_in "admin_password_confirmation", :with => "ciccio"
  fill_in "Current password", :with => @visitor[:password]
  click_button "Update"
end

When /^I erroneously edit my account details with ([^,]*), ([^,]*), and (.*)$/ do |pass, passconfirm, currpass|
  currpass = @visitor[:password] if currpass == :correct
  click_link "Edit account"
  fill_in "admin_password", :with => pass
  fill_in "admin_password_confirmation", :with => passconfirm
  fill_in "Current password", :with => currpass
  click_button "Update"
end



When /^I look at the list of admins$/ do
  visit '/'
end

When /^I visit the administrator control panel$/ do
  visit '/admin/cpanel'
end

### THEN ###
Then /^I should be signed in$/ do
  page.should have_content "Logout"
  page.should_not have_content "Sign up"
  page.should_not have_content "Login"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign up"
  page.should have_content "Login"
  page.should_not have_content "Logout"
end

Then /^I should not see private navigation items$/ do
  page.should_not have_content "Edit account"
end

Then /^I should see private navigation items$/ do
  page.should have_content "Edit account"
end

Then /^I should see navigation items for administrator$/ do
  page.should have_content "Admin"
end

Then /^I should not see navigation items for administrator$/ do
  page.should_not have_content "Admin"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see a message with confirmation instruction$/ do
  page.should have_content "A message with a confirmation link has been sent to your email address."
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "You have signed up successfully."
end

Then /^I should be asked to correct errors in the submitted data$/ do
  page.should have_content "Please review the problems below"
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Emailis invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Passwordcan't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Passworddoesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Passworddoesn't match confirmation"
end

Then /^I should see a blank current password message$/ do
  page.should have_content "Current passwordcan't be blank"
end

Then /^I should see a invalid current password message$/ do
  page.should have_content "Current passwordis invalid"
end

Then /^I should see a password too short message$/ do
  page.should have_content "Passwordis too short"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully"
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  create_admin
  page.should have_content @admin[:name]
end

Then /^I should be denied access$/ do
  page.should have_content "You are not authorized to access this page."
end

# Then /^I should see "([^"]*)"$/ do |text|
#   page.should have_content text
# end
