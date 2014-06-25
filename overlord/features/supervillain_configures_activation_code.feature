Feature: supervillain configures a new activation code
  As a supervillain
  I want to set a new activation code for the bomb
  So that I can activate it

  Scenario Outline: configure activation code
    Given I have not yet configured the activation code
    When I submit "<code>" as "Enter new activation code:" and click "Finish"
    Then I should see "<result>"

  Scenarios: valid code
    | code  | result                 |
    | 5678  | "Activation code set"  |

  Scenarios: invalid code
    | code  | result                                                |
    | 77777 | "Invalid activation code: must be 4 numerical digits" |
    | abcd  | "Invalid activation code: must be 4 numerical digits" |
    | 7a7b  | "Invalid activation code: must be 4 numerical digits" |

  Scenarios: no code
    | code | result                                 |
    |      | "Activation code set to default value" |

