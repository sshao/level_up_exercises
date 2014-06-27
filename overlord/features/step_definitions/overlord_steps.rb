Then(/^I should see "(.*)"$/) do |text|
  expect(page).to have_content /#{text}/i
end

Then(/^I should not see "(.*)"$/) do |text|
  expect(page).to_not have_content /#{text}/i
end

Then(/^I should see button "(.*)"$/) do |button|
  expect(page).to have_selector(:link_or_button, button)
end

Then(/^"(.*?)" should be "(.*?)"$/) do |button, state|
  find_button(button, disabled: true)
end

