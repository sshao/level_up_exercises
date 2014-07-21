Feature: User logs in

  As a user
  I want to login
  So that I can save a set of palettes

  Background:
    Given I am on the home page

  Scenario: User logs in successfully
    Given there exists a user "sshao" with password "password123"
    When I fill in "user[login]" with "sshao"
    And I fill in "user[password]" with "password123"
    And I click "Sign in"
    Then I should see "Signed in successfully."
    And I should see "sshao"
    And I should see "My Saved Palettes"

  Scenario: User attempts login with wrong password
    Given there exists a user "sshao" with password "password123"
    When I fill in "user[login]" with "sshao"
    And I fill in "user[password]" with "wrongpass"
    And I click "Sign in"
    Then I should see "Invalid login or password"

  Scenario: User attempts login with wrong username
    Given there exists a user "sshao" with password "password123"
    When I fill in "user[login]" with "wronguser"
    And I fill in "user[password]" with "password123"
    And I click "Sign in"
    Then I should see "Invalid login or password"

  Scenario: User attempts login with nonexistent username
    Given there does not exist a user "sshao"
    When I fill in "user[login]" with "sshao"
    And I fill in "user[password]" with "password123"
    And I click "Sign in"
    Then I should see "Invalid login or password"

