Feature: Edit User
  As a registered user of the website
  I want to edit my user profile
  so I can change my username

    Scenario: I sign in and edit my account
      Given I am logged in
      When I correctly edit my account details
      Then I should see an account edited message


    Scenario Outline: I sign in and edit my account with invalid data
      Given I am logged in
      When I erroneously edit my account details with <Password>, <PasswordConfirmation>, and <CurrentPassword>

      Then I should be asked to correct errors in the submitted data
      And I should see a <ErrorMessage> message

      Examples:
        | Password     | PasswordConfirmation | CurrentPassword | ErrorMessage             |
        | any_good_one | any_good_one         |                 | blank current password   |
        | any_good_one | any_good_one         | wrong           | invalid current password |
        | any_good_one | differentone         | :correct        | mismatched password      |
        | short        | short                | :correct        | password too short       |
