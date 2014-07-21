Given(/^I am on the home page$/) do
  visit "/"
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in field_name(field), with: value
end

When(/^I click "(.*?)"$/) do |link|
  click_link_or_button link
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end

