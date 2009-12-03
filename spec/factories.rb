Factory.define :user do |u|
  u.username "husky"
  u.password "secret"
  u.password_confirmation { |u| u.password }
  u.email "husky@xing.com"
end

Factory.define :project do |p|
  p.name "project name"
  p.description "some sort of description"
  p.warning_threshold 2
end

Factory.define :stack do |s|
  s.identifier "every one has the same identifier"
  s.category "warning"
  s.association :project, :factory => :project
end

Factory.define :notification do |n|
  n.payload "some payloadz"
  n.association :stack, :factory => :stack
end

Factory.define :exclusion do |e|
  e.name "exclusion"
  e.pattern "pattern"
  e.enabled true
end