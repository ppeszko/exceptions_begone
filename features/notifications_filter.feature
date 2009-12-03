Feature: Notifications filter

  Scenario: I want to hide unimportant notifications
    Given the project "testing_project" exists
    And the following "notification" records for project "testing_project" exist
      | category  | identifier                | payload                   |
      | exception | exception_identifier      | { "some":"payload" }      |
      | exception | this_should_be_hidden     | { "some":"other payload"} |
      | anything  | anything_identifier_other | { "some":"other payload"} |
    When I am on "projects/testing_project"
    And I follow "exclusions"
    And I follow "Create new exclusion"
    And I fill in the following:
      | name    | routing_error |
      | pattern | .*should_be   |
    And I check "enabled"
    And I press "submit"
    And I should see "routing_error"
    And I follow "testing_project"
    Then I should see "exception_identifier"
    And I should not see "this_should_be_hidden"
    
  Scenario: I want to deactivate exclusion
    Given the project "testing_project" exists
    And the following "notification" records for project "testing_project" exist
      | category  | identifier                | payload                   |
      | exception | exception_identifier      | { "some":"payload" }      |
      | exception | this_should_be_hidden     | { "some":"other payload"} |
      | anything  | anything_identifier_other | { "some":"other payload"} |
    When I am on "projects/testing_project"
    And I follow "exclusions"
    And I follow "Create new exclusion"
    And I fill in the following:
      | name    | routing_error | 
      | pattern | .*should_be   | 
    And I press "submit"
    And I should see "routing_error"
    And I follow "testing_project"
    Then I should see "this_should_be_hidden"
    
  Scenario: I want to delete exclusion
    Given the project "testing_project" exists
    And the following "notification" records for project "testing_project" exist
      | category  | identifier                | payload                   |
      | exception | exception_identifier      | { "some":"payload" }      |
      | exception | this_should_be_hidden     | { "some":"other payload"} |
      | anything  | anything_identifier_other | { "some":"other payload"} |
    When I am on "projects/testing_project"
    And I follow "exclusions"
    And I follow "Create new exclusion"
    And I fill in the following:
      | name    | routing_error | 
      | pattern | .*should_be   | 
    And I press "submit"
    And I press "delete"
    Then I should not see "routing_error"
    
  Scenario: I want to edit exclusion
    Given the project "testing_project" exists
    And the following "notification" records for project "testing_project" exist
      | category  | identifier                | payload                   |
      | exception | exception_identifier      | { "some":"payload" }      |
      | exception | this_should_be_hidden     | { "some":"other payload"} |
      | anything  | anything_identifier_other | { "some":"other payload"} |
    When I am on "projects/testing_project"
    And I follow "exclusions"
    And I follow "Create new exclusion"
    And I fill in the following:
      | name    | routing_error | 
      | pattern | .*should_be   | 
    And I press "submit"
    And I follow "edit"
    And I fill in the following:
      | name    | new_name    | 
      | pattern | .*should_be | 
    And I press "submit"
    Then I should not see "routing_error"
    And I should see "new_name"
    
  # Scenario: I want to see excluded notifications
  #   Given the project "testing_project" exists
  #   And the following "notification" records for project "testing_project" exist
  #     | category  | identifier                | payload                   |
  #     | exception | exception_identifier      | { "some":"payload" }      |
  #     | exception | this_should_be_hidden     | { "some":"other payload"} |
  #     | anything  | anything_identifier_other | { "some":"other payload"} |
  #   And I am on "projects/testing_project"
  #   And I follow "exclusions"
  #   And I follow "Create new exclusion"
  #   And I fill in the following:
  #     | name    | routing_error | 
  #     | pattern | .*should_be   | 
  #   And I press "submit"
  #   And I follow "testing_project"
  #   When I
  
