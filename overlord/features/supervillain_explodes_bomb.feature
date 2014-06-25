Feature: supervillain explodes a bomb

  As a supervillain
  I want to explode a bomb
  So that I can be rid of it

  Scenario: explode a bomb
    Given the bomb is activated
    And the deactivation code is "0000"
    When I submit "1111" as "Enter Deactivation Code" and click "Deactivate" 3 times
    Then I should see "Status: EXPLODED"
      And I should see "Enter Activation Code"
      And I should see button "Activate"
      And "Activate" should be "disabled"
      And I should see "Enter Deactivation Code" 
      And I should see button "Deactivate"
      And "Deactivate" should be "disabled"

