Given /^the following "(.+)" records? exists?$/ do |factory, table|
  table.hashes.each do |hash|
    Factory(factory, hash)
  end
end

Given /^the following "(.+)" records? for project "(.+)" exists?$/ do |factory, project_name, table|
  project = Project.find_by_name(project_name)

  table.hashes.each do |hash|
    stack = Factory(:stack, :project => project, :category => hash["category"], :identifier => hash["identifier"])
    Factory(:notification, :stack => stack, :payload => hash["payload"])
  end
end