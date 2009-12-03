Feature: Managing projects
  In order organize my notifications into project
  As a user
  I want to be able to  

  Scenario: navigating to the projects creation page
    Given I am on the projects page
    When I follow "create"
    Then I should be on the projects create page
    And I should see "Name"
    And I should see "Description"
    
  Scenario: creating a new project
    Given I am on the projects page
    When I follow "create"
    And I fill in "Name" with "project_name"
    And I fill in "Description" with "project_description"
    And I press "Submit"
    Then I should be on the homepage
    And I should see "project_name"
    And I should see "project_description"
