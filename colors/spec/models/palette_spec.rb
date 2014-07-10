require 'rails_helper'

describe Palette do
  let(:colors) { FactoryGirl.attributes_for(:palette)[:colors] }
  let(:image_url) { FactoryGirl.attributes_for(:palette)[:image_url] }

  describe "#new" do
    context "with valid parameters" do
      let(:palette) { FactoryGirl.create(:palette) }

      it "is valid" do
        expect(palette).to be_valid
      end

      it "initializes palette with passed-in colors" do
        expect(palette.colors.size).to be colors.size
      end
      
      it "appends # to beginning of each color if missing" do
        palette.colors.each do |color|
          expect(color[0]).to eq "#"
        end
      end

      it "adds the image url" do
        expect(palette.image_url).to eq image_url
      end
    end

    context "with invalid parameters" do
      it "fails if no colors are given to it" do
        colors = []
        expect(FactoryGirl.build(:palette, colors: colors)).to_not be_valid
      end

      it "fails if more than five colors are given to it" do
        colors = Array.new(6, "#FFF")
        expect(FactoryGirl.build(:palette, colors: colors)).to_not be_valid
      end

      it "fails if any color is too long" do
        colors = ["FFFFFFFFFF"]
        expect(FactoryGirl.build(:palette, colors: colors)).to_not be_valid
      end

      it "fails if any color is too short" do
        colors = ["F"]
        expect(FactoryGirl.build(:palette, colors: colors)).to_not be_valid
      end

      it "fails if any color uses invalid alpha chars" do
        colors = ["ZFF"]
        expect(FactoryGirl.build(:palette, colors: colors)).to_not be_valid
      end
    end
  end

  describe "#colors" do
    let(:palette) { FactoryGirl.create(:palette) }

    it "returns all colors" do
      expect(palette.colors).to eq colors
    end
  end
end

