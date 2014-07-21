Given(/^there exists a user "(.*?)" with email "(.*?)" and password "(.*?)"$/) do |username, email, password|
  create_user(username, password, email)
end

Given(/^there does not exist a user "(.*?)"$/) do |arg1|
end

