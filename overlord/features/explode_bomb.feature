Feature: Supervillain explodes a bomb

  As a supervillain
  I want to explode a bomb
  So that I can be rid of it

  Background: 
    Given I have a new bomb
    And the bomb's activation code is "1234"
    And the bomb's deactivation code is "0000"
    And I have configured the bomb

  Scenario: Explode a bomb
    Given the bomb is activated with code "1234"
    When I submit "1111" as "deactivation code" and click "Deactivate" 3 times
    Then I should see "Status: EXPLODED"
      And "Activate" should be disabled
      And "Deactivate" should be disabled

