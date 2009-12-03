Feature: Dealing with notifications
  
Scenario: Posting notifications to the application
  Given the project "testing_project" exists
  When the following notifications for the project "testing_project" are posted to the API 
    | category  | identifier    | payload              |
    | exception | exception_identifier | { "some":"payload" } |
  And I open to the project "testing_project" page
  Then I should see "exception"
  And I should see "exception_identifier"
