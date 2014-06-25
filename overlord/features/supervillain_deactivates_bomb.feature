Feature: supervillain deactivates bomb

  As a supervillain
  I want to deactivate a bomb
  So that I can repent of my evil ways

  Scenario: submit correct deactivation code for activated bomb
    Given the bomb is activated
    And the deactivation code is "0000"
    When I submit "0000" as "Enter Deactivation Code" and click "Deactivate"
    Then I should see "Status: Deactivated"

  Scenario: submit incorrect deactivation code for activated bomb
    Given the bomb is activated
    And the deactivation code is "0000"
    When I submit "1111" as "Enter Deactivation Code" and click "Deactivate"
    Then I should see "Wrong deactivation code"
    And I should see "Status: Activated"

  Scenario: submit correct deactivation code for deactivated bomb
    Given the bomb is deactivated
    And the deactivation code is "0000"
    When I submit "0000" as "Enter Deactivation Code" and click "Deactivate"
    Then I should see "Bomb is already deactivated"
    And I should see "Status: Deactivated"

  Scenario: submit incorrect deactivation code for deactivated bomb
    Given the bomb is deactivated
    And the deactivation code is "0000"
    When I submit "1111" as "Enter Deactivation Code" and click "Deactivate"
    Then I should see "Bomb is already deactivated"
    And I should see "Status: Deactivated"

