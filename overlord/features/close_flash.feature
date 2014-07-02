Feature: Supervillain closes a flash notice

  As a supervillain
  I want to close a flash notice
  So that I can get on with bombing things

  @javascript
  Scenario: close flash
    Given I have a flash message
    When I click the "close" button
    Then I should not see the flash message

