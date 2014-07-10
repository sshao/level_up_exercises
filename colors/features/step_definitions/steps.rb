Given(/^there exists a tumblr blog "(.*?)"$/) do |blog|
  @blog = blog
end

Given(/^the blog has at least "(\d+)" photo posts$/) do |num|
  headers = {'content-type' => 'application/json'}

  body = File.open(File.join(fixtures_path, "#{@blog}_#{num}_posts.json")).read
  uri = %r{api.tumblr.com/v2/blog/#{@blog}.tumblr.com/posts/photo\?.*&limit=#{num}}
  stub_request(:get, uri).to_return(status: 200, headers: headers, body: body)

  uri = %r{api.tumblr.com/v2/blog/#{@blog}.tumblr.com/info}
  body = File.open(File.join(fixtures_path, "#{@blog}_info.json")).read
  stub_request(:get, uri).to_return(status: 200, headers: headers, body: body)
end

When(/^I submit "(.*?)" as "(.*?)" and click "(.*?)"$/) do |blog, field, link|
  visit '/'

  field = field.gsub(/\s/, '_')
  fill_in field, :with => blog

  click_link_or_button link
end

Then(/^I should see "(\d+)" palettes and their associated photo posts$/) do |num|
  expected_count = num.to_i

  expect(page).to have_selector('div.palette', count: expected_count)
  expect(page).to have_selector('div.palette_img', count: expected_count)
end

