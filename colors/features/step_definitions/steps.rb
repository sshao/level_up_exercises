Given(/^there exists a tumblr blog "(.*?)"$/) do |blog|
  @blog = blog
end

Given(/^the blog has at least "(\d+)" photo posts$/) do |num|
  # FIXME do something with num 
  body = File.open(File.dirname(__FILE__) + '/../fixtures/blog.json').read
  stub_request(:get, %r{api.tumblr.com/v2/blog/blog.tumblr.com/posts/photo\?.*&limit=10})
    .to_return(status: 200, 
               headers: {'content-type' => 'application/json'},
               body: body)
end

When(/^I submit "(.*?)" as "(.*?)" and click "(.*?)"$/) do |blog, field, link|
  visit '/'

  field = field.gsub(/\s/, '_')
  fill_in field, :with => blog

  click_link_or_button link
end

Then(/^I should see "(\d+)" palettes and their associated photo posts$/) do |num|
  # FIXME change to test 'up to'
  expect(page).to have_selector('div.palette', count: num.to_i)
end

