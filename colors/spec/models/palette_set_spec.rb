require 'rails_helper'
require_relative '../helpers'

describe PaletteSet do
  let(:username) { "blog" }
  let(:image_url) { "spec/fixtures/images/image.jpg" }

  RSpec.configure do |c|
    c.include Helpers
  end

  before(:each) do 
    stub_photos_request(username, PULL_LIMIT)
  end

  # FIXME what SHOULD #new be doing??
  describe "#new" do
    context "with valid params" do
      let(:palette_set) { PaletteSet.new(source: username) }

      it "is valid" do
        expect(palette_set).to be_valid
      end
    end
  end

  describe "#create" do
    context "with valid params" do
      let(:palette_set) { PaletteSet.create(source: username) }
      
      it "is valid" do
        expect(palette_set).to be_valid
      end

      it "creates up to #{PULL_LIMIT} different palettes" do
        expect(palette_set.palettes.size).to be PULL_LIMIT
      end

      it "assigns a image url to each palette" do
        palette_set.palettes.each do |palette|
          expect(palette.image_url).to eq image_url
        end
      end
    end
  end
end
