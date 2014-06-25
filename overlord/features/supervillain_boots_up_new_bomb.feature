Feature: supervillain boots up a new bomb 
  As a supervillain
  I want to boot up a new bomb
  So that I can activate it 

  Scenario: finishing booting bomb
    Given the bomb has been configured
    When I click "Finish"
    Then I should see "THIS IS THE BOMB"
      And I should see "Status: Deactivated"
      And I should see "Enter Activation Code"
      And I should see "Activate"
      And I should see "Enter Deactivation Code" 
      And I should see "Deactivate"

