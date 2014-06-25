Feature: supervillain configures bomb

  As a supervillain
  I want to set new de/activation codes for the bomb
  So that I can control it

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

