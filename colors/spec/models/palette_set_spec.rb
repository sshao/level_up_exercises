require 'rails_helper'
require_relative '../connection_helpers'

describe PaletteSet do
  let(:username) { FactoryGirl.attributes_for(:palette_set)[:source] }
  let(:palette_set) { PaletteSet.create(source: username) }
  let(:palette_set_new) { PaletteSet.new(source: username) }

  RSpec.configure do |c|
    c.include ConnectionHelpers
  end
    
  before(:each) do 
    stub_info_request(username)
    stub_photos_request(username, PULL_LIMIT) 
  end

  describe "#create" do
    context "with valid params" do
      context "with successful HTTP responses from third-party API" do
        context "with photos to generate palettes from" do
          it "creates up to #{PULL_LIMIT} different palettes" do
            expect(palette_set.palettes.size).to be PULL_LIMIT
          end
        end

        context "without photos to generate from" do
          let(:username) { "nophotos" }

          it "is valid" do
            expect(palette_set).to be_valid
          end

          it "creates 0 palettes" do
            expect(palette_set.palettes).to be_empty
          end
        end
      end

      context "with unsuccessful HTTP responses from third-party API" do
        context "with unsuccessful client response" do
          let(:username) { "unauthorized" }

          it "should not save to db" do
            expect(palette_set_new.save).to be false
          end
        end

        context "with unsuccessful image response" do
          let(:username) { "invalid_image_urls" }

          it "saves to db" do
            expect(palette_set_new.save).to be true
          end

          it "does not generate a palette for the unsuccessful image read" do
            expect(palette_set.palettes).to be_empty
          end
        end
      end

      context "with any unsuccessful palette creation" do
        before(:each) do
          allow_any_instance_of(Palette).to receive(:save) { false }
        end

        it "does not generate the palette" do
          expect(PaletteSet.create(source: username).palettes).to be_empty
        end
      end
    end
    
    context "with invalid params" do
      context "with empty source" do
        let(:username) { nil }
        it { should validate_presence_of(:source) }
      end

      context "with non-existent source" do
        let(:username) { "doesnotexist" }

        it "is not valid" do
          expect(palette_set_new).to_not be_valid
        end
      end
    end
  end
end

