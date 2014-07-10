module Helpers
  def headers
    {'content-type' => 'application/json'}
  end
  
  def create_info_uri(username)
    %r{api.tumblr.com/v2/blog/#{username}.tumblr.com/info}
  end

  def create_photo_uri(username, num)
    %r{api.tumblr.com/v2/blog/#{username}.tumblr.com/posts/photo\?.*&limit=#{num}}
  end
  
  # TODO generalize requests into one method
  def stub_info_request(username)
    body = File.open(File.join(fixture_path, "#{username}_info.json")).read
    stub_request(:get, create_info_uri(username)).to_return(status: 200, headers: headers, body: body)
  end

  def stub_not_found_info_request(username)
    body = File.open(File.join(fixture_path, "#{username}_info.json")).read
    stub_request(:get, create_info_uri(username)).to_return(status: 404, headers: headers, body: body)
  end

  def stub_photos_request(username, num = 20)
    body = File.open(File.join(fixture_path, "#{username}_#{num}_posts.json")).read
    stub_request(:get, create_photo_uri(username, num)).to_return(status: 200, headers: headers, body: body)
  end

  def stub_timeout_photos_request(username, num = 20)
    body = '{"meta":{"status":401,"msg":"Not Authorized"},"response":[]}'
    stub_request(:get, create_photo_uri(username, num)).to_return(status: 401, headers: headers, body: body)
  end

  def stub_error_photos_request(username, num = 20)
    body = File.open(File.join(fixture_path, "#{username}_#{num}_posts_invalid_img_url.json")).read
    stub_request(:get, create_photo_uri(username, num)).to_return(status: 200, headers: headers, body: body)
  end
end
