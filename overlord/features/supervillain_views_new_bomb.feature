Feature: supervillain views a new bomb
  As a supervillain
  I want to open up a new bomb
  So that I can activate it 

  Scenario: view new bomb
    Given the bomb is not yet booted
    When I boot up the bomb
    Then I should see "THIS WILL BE THE BOMB"
      And I should see "Enter new activation code:"
      And I should see "Enter new deactivation code:"
      And I should see button "Finish"

