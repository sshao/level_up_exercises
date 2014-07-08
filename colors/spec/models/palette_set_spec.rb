require 'rails_helper'

describe PaletteSet do
  LIMIT = 10

  before(:each) do 
    # FIXME headers?
    body = File.open(File.dirname(__FILE__) + '/../fixtures/blog.json').read
    stub_request(:get, %r{api.tumblr.com/v2/blog/blog.tumblr.com/posts/photo\?.*&limit=10})
      .to_return(status: 200, 
                 headers: {'content-type' => 'application/json'},
                 body: body)
  end

  describe "#new" do
    let(:blog) { "blog" }
    let(:image_url) { "spec/fixtures/images/image.jpg" }

    context "with valid params" do
      let(:paletteset) { PaletteSet.new(source: blog) }

      it "is valid" do
        expect(paletteset).to be_valid
      end

      it "creates up to #{LIMIT} different palettes" do
        expect(paletteset.palettes.size).to be LIMIT
      end

      it "assigns a image url to each palette" do
        paletteset.palettes.each do |palette|
          expect(palette.image_url).to eq image_url
        end
      end
    end
  end
end
