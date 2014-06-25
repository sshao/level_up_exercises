When(/^I submit "(.*?)" as "(.*?)" and click "(.*?)"$/) do |content, field, link| 
  fill_in field, :with => content
  click_link link
end

When(/^I submit "(.*?)" as "(.*?)" and click "(.*?)" (\d+) times$/) do |content, field, link, repeat| 
  repeat.times do
    fill_in field, :with => content
    click_link link
  end
end

