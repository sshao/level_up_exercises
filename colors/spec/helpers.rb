module Helpers
  def create_uri(username, num)
    %r{api.tumblr.com/v2/blog/#{username}.tumblr.com/posts/photo\?.*&limit=#{num}}
  end

  def headers
    {'content-type' => 'application/json'}
  end

  def stub_photos_request(username, num = 20)
    body = File.open(File.join(fixture_path, "#{username}_#{num}_posts.json")).read
    stub_request(:get, create_uri(username, num)).to_return(status: 200, headers: headers, body: body)
  end

  def stub_timeout_photos_request(username, num = 20)
    body = '{"meta":{"status":401,"msg":"Not Authorized"},"response":[]}'
    stub_request(:get, create_uri(username, num)).to_return(status: 401, headers: headers, body: body)
  end

  def stub_error_photos_request(username, num = 20)
    body = File.open(File.join(fixture_path, "#{username}_#{num}_posts_invalid_img_url.json")).read
    stub_request(:get, create_uri(username, num)).to_return(status: 200, headers: headers, body: body)
  end
end
