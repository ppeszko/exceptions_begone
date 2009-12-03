Feature: Manage Users
  In order see notifications
  As an user
  I want to log in
  
  Scenario: Member
    Given the following "user" record exist
      | username | password |
      | bob      | secret   |
    And I am on the login page
    When I fill in "Login" with "bob"
    And I fill in "Password" with "secret"
    And I press "Login"
    Then I should see "Logged in"
    