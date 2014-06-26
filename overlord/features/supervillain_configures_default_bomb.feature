Feature: supervillain configures a default bomb
  As a supervillain
  I want to boot up a new bomb
  So that I can activate it 

  Scenario: boot default bomb
    Given I have a new bomb
    When I have configured the bomb
    Then I should see "THIS IS THE BOMB"
      And I should see "Status: Deactivated"
      And I should see "Enter Activation Code"
      And I should see button "Activate"
      And I should see "Enter Deactivation Code" 
      And I should see button "Deactivate"
      And I should not see "Invalid"
