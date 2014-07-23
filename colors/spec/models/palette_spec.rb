require 'rails_helper'

describe Palette do
  let(:expected_colors) { ["#494E54", "#95989E", "#BDBCBA", "#C1B5B1", "#C3C9C8"] }
  let(:image_url) { FactoryGirl.attributes_for(:palette)[:image_url] }

  describe "#new" do
    context "with valid parameters" do
      let(:palette) { Palette.create(image_url: image_url) }

      it "generates the correct colors" do
        expect(palette.colors).to eq expected_colors
      end

      it "saves the image url" do
        expect(palette.image_url).to eq image_url
      end
    end

    context "with invalid parameters" do
      it { should validate_presence_of(:image_url) }

      it "does not generate a palette for an unsuccessful image read" do
        image_url = "does_not_exist.jpg"
        expect(Palette.new(image_url: image_url).save).to be false
      end
    end
  end

  describe "#colors" do
    it "should be read-only" do
      palette = Palette.create(image_url: image_url)
      palette.update_attributes colors: ["#000"]
      expect(palette.reload.colors).to eq expected_colors
    end
  end
end

