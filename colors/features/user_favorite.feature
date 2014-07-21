Feature: User favorites a palette set

  As a user
  I want to favorite a palette set
  So I can find it later

  Background:
    Given that I am signed in
    And I am on a palette set's page
    #FIXME "I" am user "sshao" ... applies for other features 

  Scenario: User favorites a palette set
    When I click "Favorite"
    Then I should see "Favorited"

  Scenario: User views list of favorited palette sets
    Given I have favorited some palette sets
    # FIXME rename to match 'favorites'
    When I click "My Saved Palettes" 
    Then I should see all of my favorited palette sets

