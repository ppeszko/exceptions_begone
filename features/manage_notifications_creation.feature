Feature: Manage notifications
  In order Create a notification
  As a application
  I want post my data to notifications
  
  Scenario Outline: posting exception
    Given the following "project" record exists
      | name       | description              |
      | production | some sort of identifier  |
    When posting on project <project> notification category <category> with identifier <identifier> with payload <payload>
    Then response status should be Created
    And the following stack should be created
      | identifier   | category   |
      | <identifier> | <category> |
    And the following payload should be saved
      | identifier   | payload   |
      | <identifier> | <payload> |
      
    Examples:
       | project    | category     | identifier        | payload                                            |
       | production | notification | some_name         | {"backtrace":"some data from error_notifications"} |
       | production | exception    | this is a warning | {"environment":"production/ncomplicated text"}     |
