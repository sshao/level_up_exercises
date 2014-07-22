Feature: User favorites a palette set

  As a user
  I want to favorite a palette set
  So I can find it later

  Background:
    Given that I am signed in
    And I am on a palette set's page

  Scenario: User favorites a palette set
    When I click "Favorite"
    Then I should see "Favorited"

  Scenario: User views list of favorited palette sets
    Given I have favorited some palette sets
    When I click "Favorites"
    Then I should see all of my favorited palette sets

