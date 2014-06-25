Given(/^the bomb is not yet booted$/) do
end

When(/^I boot up the bomb$/) do
  visit "/"
end

Then(/^I should see "(.*)"$/) do |text|
  expect(page).to have_content text
end

Then(/^I should see button "(.*)"$/) do |button|
  expect(page).to have_selector(:link_or_button, button)
end

Given(/^I have not yet configured the activation code$/) do
end

When(/^I click "(.*?)"$/) do |link|
  click_link link
end

Given(/^I have not yet configured the deactivation code$/) do
end

Given(/^the bomb has been configured$/) do
end

Given(/^the bomb is not yet activated$/) do
end

Given(/^the activation code is "(.*?)"$/) do |code|
  expect(Bomb.any_instance).to receive(:activation_code) { code.to_i }
end

Given(/^the bomb is activated$/) do
  expect(Bomb.any_instance).to receive(:activated?) { true }
end

Given(/^the bomb is deactivated$/) do
  expect(Bomb.any_instance).to receive(:activated?) { false }
end

Given(/^the deactivation code is "(.*?)"$/) do |code|
  expect(Bomb.any_instance).to receive(:deactivation_code) { code.to_i }
end

Then(/^"(.*?)" should be "(.*?)"$/) do |button, state|
  field_labeled(button, disabled: true)
end

