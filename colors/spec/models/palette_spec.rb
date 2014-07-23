require 'rails_helper'

describe Palette do
  let(:colors) { FactoryGirl.attributes_for(:palette)[:colors] }
  let(:image_url) { FactoryGirl.attributes_for(:palette)[:image_url] }

  describe "#new" do
    context "with valid parameters" do
      let(:palette) { Palette.create(colors: colors, image_url: image_url) }

      it "initializes palette with passed-in colors" do
        expect(palette.colors).to eq colors
      end
      
      it "appends # to beginning of each color if missing" do
        palette.colors.each do |color|
          expect(color[0]).to eq "#"
        end
      end

      it "saves the image url" do
        expect(palette.image_url).to eq image_url
      end
    end

    context "with invalid parameters" do
      it { should validate_presence_of(:image_url) }

      it { should_not allow_value([]).for(:colors) }

      it { should_not allow_value(Array.new(6, "#FFF")).for(:colors) }

      it { should_not allow_value(["FFFFFFFFFF"]).for(:colors) }

      it { should_not allow_value(["F"]).for(:colors) }

      it { should_not allow_value(["ZFF"]).for(:colors) }
    end
  end
end

