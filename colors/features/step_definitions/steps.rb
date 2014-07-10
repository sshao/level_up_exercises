Given(/^there (?:does not )*exist(?:s*) a tumblr blog "(.*?)"$/) do |blog|
  @blog = blog
  stub_info_request(@blog)
end

Given(/^it has at least "(\d+)" photo posts$/) do |num|
  stub_photos_request(@blog, num)
end

Given(/^it has 0 photo posts$/) do 
  stub_photos_request(@blog, PULL_LIMIT)
end

When(/^I submit it as "(.*?)" and click "(.*?)"$/) do |field, link|
  visit '/'

  field = field.gsub(/\s/, '_')
  fill_in field, :with => @blog

  click_link_or_button link
end

Then(/^I should see "(\d+)" palettes and their associated photo posts$/) do |num|
  expected_count = num.to_i

  expect(page).to have_selector('div.palette', count: expected_count)
  expect(page).to have_selector('div.palette_img', count: expected_count)
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end
