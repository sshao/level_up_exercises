module Helpers
  def headers
    {'content-type' => 'application/json'}
  end

  def status(json_string)
    JSON.parse(json_string)["meta"]["status"]
  end
  
  def create_info_uri(username)
    %r{api.tumblr.com/v2/blog/#{username}.tumblr.com/info}
  end

  def create_photo_uri(username, num = 20)
    %r{api.tumblr.com/v2/blog/#{username}.tumblr.com/posts/photo\?.*&limit=#{num}}
  end
  
  def stub_info_request(username)
    body = File.open(File.join(fixture_path, "#{username}_info.json")).read
    stub_request(:get, create_info_uri(username))
      .to_return(status: status(body), headers: headers, body: body)
  end

  def stub_photos_request(username, num = 20)
    body = File.open(File.join(fixture_path, "#{username}_#{num}_posts.json")).read
    stub_request(:get, create_photo_uri(username, num))
      .to_return(status: status(body), headers: headers, body: body)
  end
end
