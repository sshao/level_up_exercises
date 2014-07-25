Given(/^I am on the home page$/) do
  visit "/"
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in field_name(field), with: value
end

When(/^I click "(.*?)"$/) do |link|
  click_link_or_button link
end

Then(/^I should see (button )*"(.*?)"$/) do |button, text|
  if button
    expect(page).to have_selector("input[value='#{text}']")
  else
    expect(page).to have_content(text)
  end
end

Then(/^button "(.*?)" should be disabled$/) do |button|
  expect(page).to have_button(button, disabled: true)
end
