Feature: Organize notifications

  Scenario: view exceptions
    Given the following "user" records exist
      | username | password |
      | bob      | secret   |
    And the following "project" records exist
      | name    | description         |
      | preview | preview identifier |
    And the following "notification" records exist
      | identifier | payload |
    And I am logged in as "bob" with password "secret"
    When I am on projects page
    And I follow "preview"
    Then I should see "Notifications"
    
  Scenario: ordering notifications by default
    Given the project "testing_project" exists
    And there are no "stacks"
    When the following notifications for the project "testing_project" are posted to the API 
      | category  | identifier                | payload                   |
      | exception | exception_identifier      | { "some":"payload" }      |
      | exception | exception_identifier      | { "some":"other payload"} |
      | anything  | anything_identifier_other | { "some":"other payload"} |
    And I open to the project "testing_project" page
    Then I should see "exception" "1" time
    And  I should see "exception" before "anything"

  Scenario: ordering notifications by category
    Given the project "testing_project" exists
    And there are no "stacks"
    When the following notifications for the project "testing_project" are posted to the API 
      | category  | identifier                | payload                   |
      | exception | exception_identifier      | { "some":"payload" }      |
      | exception | exception_identifier      | { "some":"other payload"} |
      | anything  | anything_identifier_other | { "some":"other payload"} |
    And I open to the project "testing_project" page
    And I follow "Category"
    Then  I should see "anything" before "exception"
      
  Scenario: searching for notification identifier
    Given the project "testing_project" exists
    And there are no "stacks"
    When the following notifications for the project "testing_project" are posted to the API
      | category     | identifier   | payload                   |
      | exception    | test_message | { "some":"other payload"} |
      | exception    | find_me      | { "some":"other payload"} |
      | notification | find_me      | { "some":"other payload"} |
    And I open to the project "testing_project" page
    And I fill in "search" with "find_me"
    And I press "search"
    Then I should see "exception" "1" time
    And I should see "notification" "1" time  
    
  Scenario: processing notifications from notifications view
    Given the project "testing_project" exists
    And the following "notification" records for project "testing_project" exist
      | category  | identifier           | payload              |
      | exception | exception_identifier | { "some":"payload" } |
    And the following "user" records exist
      | username | password |
      | bob      | secret   |
    And I am logged in as "bob" with password "secret"
    And I am on the "projects/testing_project"
    And I follow "exception_identifier"
    When I press "processing"
    Then I should see "done"
