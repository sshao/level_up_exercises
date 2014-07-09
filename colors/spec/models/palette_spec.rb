require 'rails_helper'

describe Palette do
  describe "#new" do
    let(:colors) { [ "ECD078", "#D95B43", "#C02", "542", "#53777a" ] }
    let(:image_url) { "http://imageurl.com/image.jpg" }

    context "with valid parameters" do
      it "is valid" do
        expect(Palette.new(colors: colors)).to be_valid
      end

      it "initializes palette with passed-in colors" do
        palette = Palette.new(colors: colors)
        expect(palette.colors.size).to be colors.size
      end
      
      it "appends # to beginning of each color if missing" do
        palette = Palette.new(colors: colors)

        palette.colors.each do |color|
          expect(color[0]).to eq "#"
        end
      end

      it "adds the image url" do
        palette = Palette.new(colors: colors, image_url: image_url)
        expect(palette.image_url).to eq image_url
      end
    end

    context "with invalid parameters" do
      it "fails if no colors are given to it" do
        colors = []
        expect(Palette.new(colors: colors)).to_not be_valid
      end

      it "fails if more than five colors are given to it" do
        colors = Array.new(6, "#FFF")
        expect(Palette.new(colors: colors)).to_not be_valid
      end

      it "fails if any color is too long" do
        colors = ["FFFFFFFFFF"]
        expect(Palette.new(colors: colors)).to_not be_valid
      end

      it "fails if any color is too short" do
        colors = ["F"]
        expect(Palette.new(colors: colors)).to_not be_valid
      end

      it "fails if any color uses invalid alpha chars" do
        colors = ["ZFF"]
        expect(Palette.new(colors: colors)).to_not be_valid
      end
    end
  end

  describe "#colors" do
    let(:colors) { [ "ECD078", "#D95B43", "#C02", "542", "#53777a" ] }
    let(:palette) { Palette.new(colors: colors) }

    it "returns all colors" do
      expect(palette.colors).to eq colors
    end
  end
end

