Feature: Supervillain boots up a new bomb
  As a supervillain
  I want to boot up a new bomb
  So that I can activate it 

  Scenario: View new bomb
    Given the bomb is not yet booted
    When I boot up the bomb
    Then I should see "THIS WILL BE THE BOMB"

  Scenario: Boot default bomb
    Given I have a new bomb
    When I have configured the bomb
    Then I should see "THIS IS THE BOMB"

