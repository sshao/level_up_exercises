require 'rails_helper'

describe PaletteSet do
  LIMIT = 10

  before(:all) do 
    # FIXME headers?
    # FIXME post limit
    body = File.open(File.dirname(__FILE__) + '/../fixtures/blog.json').read
    stub_request(:get, %r{api.tumblr.com/v2/blog/blog.tumblr.com/posts/photo})
      .to_return(status: 200, 
                 headers: {'content-type' => 'application/json'},
                 body: body)
  end

  describe "#new" do
    let(:blog) { "blog" }

    context "with valid params" do
      it "creates up to #{LIMIT} different palettes" do
        expect(PaletteSet.new(blog).palettes.count).to be LIMIT
      end
    end
  end
end
