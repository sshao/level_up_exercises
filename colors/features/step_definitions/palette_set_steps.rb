Given(/^there (?:does not )*exist(?:s*) a tumblr with username "(.*?)"$/) do |blog|
  @blog = blog
  stub_info_request(@blog)
end

Given(/^it has at least "(\d+)" photo posts$/) do |num|
  stub_photos_request(@blog, num)
end

Given(/^it has 0 photo posts$/) do 
  stub_photos_request(@blog, PULL_LIMIT)
end

Given(/^palettes have already been generated for it$/) do 
  create_palette_set(@blog)
end

Then(/^I should see "(\d+)" palettes(?: and their associated photo posts)*$/) do |num|
  expected_count = num.to_i

  expect(page).to have_selector("div.palette", count: expected_count)
  expect(page).to have_selector("div.palette_img", count: expected_count)
end

