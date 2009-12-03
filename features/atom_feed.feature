Feature: Atom feed

Scenario: Presenting stacks to a rss reader
  Given the project "testing_project" exists
  When the following notifications for the project "testing_project" are posted to the API 
    | category  | identifier    | payload              |
    | exception | exception_identifier | { "some":"payload" } |
  And I open to the project "testing_project" page 
  And I follow "Atom Feed"
  And I should see "[incoming count:1]"
  
  Given the project "testing_project" exists
  And there are no "stacks"
  And I open to the project "testing_project" page 
  And I follow "Atom Feed"
  And I should not see "[incoming count:1]"