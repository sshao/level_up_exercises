Given(/^the bomb is not yet booted$/) do
end

When(/^I boot up the bomb$/) do
  visit "/"
end

Then(/^I should see "(.*)"$/) do |text|
  expect(page).to have_content /#{text}/i
end

Then(/^I should see button "(.*)"$/) do |button|
  expect(page).to have_selector(:link_or_button, button)
end

Given(/^I have not yet configured the activation code$/) do
  visit "/"
end

When(/^I click "(.*?)"$/) do |link|
  click_link_or_button link
end

Given(/^I have not yet configured the deactivation code$/) do
  visit "/"
end

Given(/^the bomb has been configured$/) do
  visit "/"
end

Given(/^I have a new bomb$/) do
  visit "/"
end

Given(/^I have configured the bomb$/) do
  click_button "Finish"
end

Given(/^the bomb is not yet activated$/) do
end

Given(/^the bomb's activation code is "(.*?)"$/) do |code|
  visit "/"
  fill_in "Enter new activation code:", :with => code
end

Given(/^the bomb is activated with code "(.*?)"$/) do |code|
  fill_in "Enter Activation Code", :with => code
  click_button "Activate"
end

Given(/^the bomb is deactivated$/) do
end

Given(/^the bomb's deactivation code is "(.*?)"$/) do |code|
  visit "/"
  fill_in "Enter new deactivation code:", :with => code
end

Then(/^"(.*?)" should be "(.*?)"$/) do |button, state|
  find_button(button, disabled: true)
end

