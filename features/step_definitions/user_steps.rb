Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  unless username.blank?
    visit login_url
    fill_in "Login", :with => username
    fill_in "Password", :with => password
    click_button "Login"
  end
end