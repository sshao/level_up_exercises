Given(/^there exists a user "(.*?)" with password "(.*?)"$/) do |username, password|
  create_user(username, password)
end

When(/^I submit "(.*?)" as "(.*?)" and "(.*?)" as "(.*?)"$/) do |username, username_field, password, password_field|
  login(username, username_field, password, password_field)
end

Given(/^there does not exist a user "(.*?)"$/) do |arg1|
end

