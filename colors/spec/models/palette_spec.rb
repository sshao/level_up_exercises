require 'rails_helper'

describe Palette do
  let(:colors) { [ "#ECD078", "#D95B43", "#C02942", "#542437", "#53777A" ] }
  let(:no_pound_colors) { [ "ECD078", "D95B43", "C02942", "542437", "53777A" ] }
  let(:short_colors) { [ "#ECD", "#D95", "#C02942", "#542", "#53777A" ] }
  let(:image_url) { "http://imageurl.com/image.jpg" }

  describe "#new" do
    context "with valid parameters" do
      context "full hex colors" do
        context "with # included" do
          it "is valid" do
            expect(Palette.new(colors: colors)).to be_valid
          end

          it "initializes palette with passed-in colors" do
            palette = Palette.new(colors: colors)
            expect(palette.colors.size).to be 5
          end
        end

        context "without # included" do
          it "is valid" do
            expect(Palette.new(colors: no_pound_colors)).to be_valid
          end

          it "initializes palette with passed-in colors" do
            palette = Palette.new(colors: no_pound_colors)
            expect(palette.colors.size).to be 5
          end

          it "appends # to beginning of each color" do
            palette = Palette.new(colors: no_pound_colors)
            expect(palette.colors.first[0]).to eq "#"
          end
        end
      end
      
      context "short hex colors" do
        it "is valid" do
          expect(Palette.new(colors: short_colors)).to be_valid
        end

        it "initializes palette with passed-in colors" do
          palette = Palette.new(colors: short_colors)
          expect(palette.colors.size).to be 5
        end
      end

      it "adds the image url" do
        palette = Palette.new(colors: colors, image_url: image_url)
        expect(palette.image_url).to eq image_url
      end
    end

    context "with invalid parameters" do
      it "fails if no colors are given to it" do
        expect(Palette.new(colors: [])).to_not be_valid
      end

      it "fails if more than five colors are given to it" do
        six_colors = colors << "#FFFFFF"
        expect(Palette.new(colors: six_colors)).to_not be_valid
      end

      it "fails if the first argument is not a valid hex color" do
        colors[0] = "FFFFFFF"
        expect(Palette.new(colors: colors)).to_not be_valid
      end

      it "fails if the second argument is not a valid hex color" do
        colors[1] = "FFFFFFF"
        expect(Palette.new(colors: colors)).to_not be_valid
      end

      it "fails if the last argument is not a valid hex color"  do
        colors[4] = "#zzz"
        expect(Palette.new(colors: colors)).to_not be_valid
      end
    end
  end

  describe "#colors" do
    let(:palette) { Palette.new(colors: colors) }

    it "returns all colors" do
      expect(palette.colors).to eq colors
    end
  end
end

