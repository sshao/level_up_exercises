module Helpers
  def stub_10_photos_request
    # FIXME headers?
    body = File.open(File.dirname(__FILE__) + '/fixtures/blog.json').read
    stub_request(:get, %r{api.tumblr.com/v2/blog/blog.tumblr.com/posts/photo\?.*&limit=10})
      .to_return(status: 200, 
                 headers: {'content-type' => 'application/json'},
                 body: body)
  end
end
