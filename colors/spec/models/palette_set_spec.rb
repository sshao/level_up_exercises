require 'rails_helper'
require_relative '../helpers'

describe PaletteSet do
  let(:username) { "blog" }
  let(:image_url) { "spec/fixtures/images/image.jpg" }

  RSpec.configure do |c|
    c.include Helpers
  end

  # FIXME what SHOULD #new be doing??
  describe "#new" do
    before(:each) do 
      stub_photos_request(username, PULL_LIMIT)
    end

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

      context "with successful HTTP responses" do
        before(:each) do 
          stub_photos_request(username, PULL_LIMIT)
        end
        
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

      context "with unsuccessful HTTP responses" do
        context "with unsuccessful client response" do
          before(:each) do 
            stub_timeout_photos_request(username, PULL_LIMIT)
          end
          
          it "should not save to db" do
            expect(PaletteSet.new(source: username).save).to be false
          end
        end

        context "with unsuccessful image response" do
          before(:each) do
            stub_error_photos_request(username, PULL_LIMIT)
          end

          it "saves to db" do
            expect(PaletteSet.new(source: username).save).to be true
          end

          it "does not generate a palette for the unsuccessful image read" do
            expect(palette_set.palettes).to be_empty
          end
        end

        context "with corrupted image (palette)" do
          it "does not save the palette"
        end
      end
    end
    
    context "with invalid params" do
      it "is not valid"
    end

  end
end
