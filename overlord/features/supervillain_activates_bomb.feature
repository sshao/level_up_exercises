Feature: supervillain activates a bomb

  As a supervillain
  I want to activate a bomb
  So that I can explode it

  Background:
    Given I have a new bomb
    And the bomb's activation code is "1234"
    And the bomb's deactivation code is "0000"
    And I have configured the bomb
  
  Scenario: submit correct activation code for deactivated bomb
    Given the bomb is deactivated
    When I submit "1234" as "Enter Activation Code" and click "Activate"
    Then I should see "Status: Activated"
    And I should not see "Invalid"
    And I should not see "Wrong"

  Scenario: submit incorrect activation code for deactivated bomb
    Given the bomb is deactivated
    When I submit "4444" as "Enter Activation Code" and click "Activate"
    Then I should see "Wrong activation code"
    And I should see "Status: Deactivated"
    And I should not see "Invalid"

  Scenario: submit activation code for activated bomb
    Given the bomb is activated with code "1234"
    When I submit "1234" as "Enter Activation Code" and click "Activate"
    Then I should see "Bomb is already activated"
    And I should see "Status: Activated"
    And I should not see "Invalid"
    And I should not see "Wrong"

  Scenario: submit incorrect activation code for activated bomb
    Given the bomb is activated with code "1234"
    When I submit "4444" as "Enter Activation Code" and click "Activate"
    Then I should see "Bomb is already activated"
    And I should see "Status: Activated"
    And I should not see "Invalid"
    And I should not see "Wrong"

