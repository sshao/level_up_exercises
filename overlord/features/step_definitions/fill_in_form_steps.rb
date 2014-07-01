When(/^I submit "(.*?)" as "(.*?)" and click "(.*?)"\s*(?:(\d+) times)?$/) do |content, field, link, repeat| 
  repeat = [1, repeat.to_i].max
  
  repeat.times do
    field = field.gsub(/\s/, '_')
    fill_in field, :with => content
    click_link_or_button link
  end
end

