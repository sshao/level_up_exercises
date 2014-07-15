Feature: User logs in

  As a user
  I want to login
  So that I can save a set of palettes

  Scenario: User logs in successfully
    Given there exists a user "sshao" with password "password123"
    When I submit "sshao" as "user[login]" and "password123" as "user[password]"
    Then I should see "Signed in successfully."
    And I should see "sshao"
    And I should see "My Saved Palettes"

  Scenario: User attempts login with wrong password
    Given there exists a user "sshao" with password "password123"
    When I submit "sshao" as "user[login]" and "user[password]" as "user[password]"
    Then I should see "Login failed: password does not match username"

  Scenario: User attempts login with wrong username
    Given there exists a user "sshao" with password "password123"
    When I submit "dshao" as "user[login]" and "password123" as "user[password]"
    Then I should see "Login failed: password does not match username"

  Scenario: User attempts login with nonexistent username
    Given there does not exist a user "sshao"
    When I submit "sshao" as "user[login]" and "password123" as "user[password]"
    Then I should see "Login failed: user does not exist"

