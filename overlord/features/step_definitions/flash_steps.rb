Given(/^I have a flash message$/) do
  visit "/"
  click_link_or_button "Finish"
end

When(/^I click the "(.*?)" button$/) do |button_class|
  button_class = button_class.gsub(/\s/, '_')
  page.find(".close").click
end

Then(/^I should not see the flash message$/) do
  page.should_not have_css('div.flash')
end
