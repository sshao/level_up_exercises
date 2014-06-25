Feature: supervillain activates a bomb

  As a supervillain
  I want to activate a bomb
  So that I can explode it
  
  Scenario: submit correct activation code for deactivated bomb
    Given the bomb is not yet activated
      And the activation code is "1234"
    When I submit "1234" as "Enter Activation Code" and click "Activate"
    Then I should see "Status: Activated"

  Scenario: submit incorrect activation code for deactivated bomb
    Given the bomb is not yet activated
    And the activation code is "1234"
    When I submit "4444" as "Enter Activation Code" and click "Activate"
    Then I should see "Wrong activation code"
    And I should see "Status: Deactivated"

  Scenario: submit activation code for activated bomb
    Given the bomb is activated
    And the activation code is "1234"
    When I submit "1234" as "Enter Activation Code" and click "Activate"
    Then I should see "Bomb is activated"
    And I should see "Status: Activated"

  Scenario: submit incorrect activation code for activated bomb
    Given the bomb is activated
    And the activation code is "1234"
    When I submit "4444" as "Enter Activation Code" and click "Activate"
    Then I should see "Bomb is activated"
    And I should see "Status: Activated"
