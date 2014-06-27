Given(/^the bomb is not yet booted$/) do
end

When(/^I boot up the bomb$/) do
  visit "/"
end

Given(/^I have a new bomb$/) do
  visit "/"
end

Given(/^I have not yet configured the activation code$/) do
  visit "/"
end

Given(/^I have not yet configured the deactivation code$/) do
  visit "/"
end

Given(/^I have configured the bomb$/) do
  click_button "Finish"
end

Given(/^the bomb's activation code is "(.*?)"$/) do |code|
  visit "/"
  fill_in "Enter new activation code:", :with => code
end

Given(/^the bomb's deactivation code is "(.*?)"$/) do |code|
  visit "/"
  fill_in "Enter new deactivation code:", :with => code
end

Given(/^the bomb is deactivated$/) do
end

Given(/^the bomb is activated with code "(.*?)"$/) do |code|
  fill_in "Enter Activation Code", :with => code
  click_button "Activate"
end

