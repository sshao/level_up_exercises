Feature: supervillain activates a deactivated bomb

  As a supervillain
  I want to activate a bomb
  So that I can explode it

  Scenario: submit correct activation code
    Given the bomb is not yet activated
      And the activation code is "1234"
    When I submit "1234" as "Enter Activation Code" and click "Activate"
    Then I should see "Status: Activated"

  Scenario: submit incorrect activation code
    Given the bomb is not yet activated
    And the activation code is "1234"
    When I submit "4444" as "Enter Activation Code" and click "Activate"
    Then I should see "Wrong activation code"
    And I should see "Status: Deactivated"
