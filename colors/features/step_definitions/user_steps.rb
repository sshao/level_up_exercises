Given(/^there exists a user "(.*?)" with password "(.*?)"$/) do |username, password|
  create_user(username, password)
end

Given(/^there does not exist a user "(.*?)"$/) do |arg1|
end

