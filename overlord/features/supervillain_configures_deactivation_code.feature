Feature: supervillain configures a new deactivation code
  As a supervillain
  I want to set a new deactivation code for the bomb
  So that I can deactivate it

  Scenario Outline: configure deactivation code
    Given I have not yet configured the deactivation code
    When I submit "<code>" as "Enter new deactivation code:" and click "Finish"
    Then I should see "<result>"
    
  Scenarios: valid code
    | code | result                   |
    | 5678 | "Deactivation code set"  |

  Scenarios: invalid code
    | code  | result                                                  |
    | 77777 | "Invalid deactivation code: must be 4 numerical digits" |
    | abcd  | "Invalid deactivation code: must be 4 numerical digits" |
    | 7a7b  | "Invalid deactivation code: must be 4 numerical digits" |

  Scenarios: no code
    | code | result                                   |
    |      | "Deactivation code set to default value" |

