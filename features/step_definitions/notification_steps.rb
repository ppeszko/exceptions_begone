When /^posting on project (.+) notification category (.+) with identifier (.+) with payload (.+)$/ do |project_name, category, identifier, payload|
  header("Content-type", "application/json")
  header("Accept", "application/json")
  
  project = Project.find_by_name(project_name)
  visit project_notifications_path(project), :post, build_notification(category, identifier, payload)
end

Then /^response status should be (.+)$/ do |status|
  response.status.should contain(status)
end

Then /^the following (.+) should be created$/ do |table_name, table|
  klas = table_name.classify.constantize
  table.hashes.each do |hash|
    hash.each do |method_name, value|
      assert_not_nil klas.__send__("find_by_#{method_name}", value)
    end
  end
end

Then /^the following payload should be saved$/ do |table|
  table.hashes.each do |notification_hash|
    notification = Stack.find_by_identifier(notification_hash[:identifier]).notifications.last
    assert_equal notification_hash[:payload], notification.payload
  end
end

When /^the following notifications for the project "([^\"]*)" are posted to the API$/ do |project_name, table|
  header("Content-type", "application/json")
  header("Accept", "application/json")
  table.hashes.each do |notification|
    project = Project.find_by_name(project_name)
    visit project_notifications_path(project), :post, ActiveSupport::JSON.encode(:notification => notification) 
  end
end

When /^I open to the project "([^\"]*)" page$/ do |project|
  project = Project.find_by_name(project)
  visit project_stacks_path(project)
end

Then /^I should see "([^\"]*)" "([^\"]*)" times?$/ do |text, counter|
  response.should have_selector("td", :class => text, :count => counter.to_i)
end

Given /^there are no "([^\"]*)"$/ do |table_name|
  table = table_name.singularize.capitalize.constantize
  table.destroy_all
  assert table.all.empty?
end

# not working :(
# Then /^I should see "([^\"]*)" on the first place$/ do |text|
#   response.should have_selector("tr", :class => "entry") do |row|
#     row[0].should have_selector("td", :class => text)
#     row[1].should_not have_selector("td", :class => text) do |hmm|
#       require "ruby-debug"; Debugger.start; debugger
#       p hmm
#     end
#   end
# end

Then /^I should see "([^\"]*)" before "([^\"]*)"$/ do |first_class, second_class|
  response.should have_selector("tr", :class => "entry") do |row|
    row[0].should have_selector("td", :class => first_class)
    row[1].should have_selector("td", :class => second_class)
  end
end

Then /^I should see "([^\"]*)" in "([^\"]*)" column$/ do |time, elem_name|
  if time =~ /^\#\{(.+)\}$/
    time = eval($1).to_s(:short)
  end
  response.should have_selector("td", :class => elem_name) do |elem|
    elem.should contain(time)
  end
end

def build_notification(category, identifier, payload)
  <<-JSON
  { 
    "notification":{
      "category":"#{category}",
      "identifier":"#{identifier}",
      "payload": #{payload}
    }
  }
  JSON
end