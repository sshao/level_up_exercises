require 'rails_helper'
require_relative '../helpers'

describe PaletteSet do
  LIMIT = 10

  RSpec.configure do |c|
    c.include Helpers
  end

  before(:each) do 
    stub_10_photos_request
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
