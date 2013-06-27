Feature: Sign up
  In order to get access to protected sections of the site
  As a admin
  I want to be able to sign up

    Background:
      Given I am not logged in

    Scenario: Admin signs up with valid data
      When I sign up with valid admin data
      Then I should see a message with confirmation instruction

    Scenario: Admin signs up with invalid email
      When I sign up with an invalid email
      Then I should be asked to correct errors in the submitted data
      And I should see an invalid email message

    Scenario: Admin signs up without password
      When I sign up without a password
      Then I should be asked to correct errors in the submitted data
      And I should see a missing password message

    Scenario: Admin signs up without password confirmation
      When I sign up without a password confirmation
      Then I should be asked to correct errors in the submitted data
      And I should see a missing password confirmation message

    Scenario: Admin signs up with mismatched password and confirmation
      When I sign up with a mismatched password confirmation
      Then I should be asked to correct errors in the submitted data
      And I should see a mismatched password message
