Given /the project "(.*)" exists/ do |projectname|
  Given "I am on the projects page"
  When %Q(I follow "create")
  And %Q(I fill in "Name" with "#{projectname}")
  And %Q(I fill in "Description" with "project_description")
  And %Q(I press "Submit")
end
