Feature: User logs in

  As a user
  I want to login
  So that I can save a set of palettes

  Background:
    Given I am on the home page
    And there exists a user "sshao" with email "sshao@email.com" and password "password123"

  Scenario: User logs in successfully with username
    When I fill in "user[login]" with "sshao"
    And I fill in "user[password]" with "password123"
    And I click "Sign in"
    Then I should see "Signed in successfully."
    And I should see "sshao"
    And I should see "Favorites"

