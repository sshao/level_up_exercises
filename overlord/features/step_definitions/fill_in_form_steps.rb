When(/^I submit "(.*?)" as "(.*?)" and click "(.*?)"$/) do |content, field, link| 
  fill_in field, :with => content
  click_link_or_button link
end

When(/^I submit "(.*?)" as "(.*?)" and click "(.*?)" (\d+) times$/) do |content, field, link, repeat| 
  repeat.to_i.times do
    fill_in field, :with => content
    click_link_or_button link
  end
end

