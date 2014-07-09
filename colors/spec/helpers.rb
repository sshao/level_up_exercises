module Helpers
  def stub_photos_request(username, num = 20)
    body = File.open(File.join(fixture_path, "#{username}_#{num}_posts.json")).read
    uri = %r{api.tumblr.com/v2/blog/#{username}.tumblr.com/posts/photo\?.*&limit=#{num}}
    headers = {'content-type' => 'application/json'}

    stub_request(:get, uri).to_return(status: 200, headers: headers, body: body)
  end
end
