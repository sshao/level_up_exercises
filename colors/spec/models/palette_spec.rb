require 'rails_helper'

describe PaletteSet do
  let(:colors) { [ "#ECD078", "#D95B43", "#C02942", "#542437", "#53777A" ] }

  describe "#new" do
    context "with valid parameters" do
      it "initializes palette with passed-in colors" do
        palette = Palette.new(colors)
        expect(palette.colors.size).to be 5
      end
    end

    context "with invalid parameters" do
      it "fails if no colors are given to it" do
        expect { Palette.new([]) }.to raise_error(InvalidColorInput, "No colors provided")
      end

      it "fails if more than five colors are given to it" do
        six_colors = colors << "#FFFFFF"
        expect { Palette.new(six_colors) }.to raise_error(InvalidColorInput, "Too many colors provided")
      end

      it "fails if the first argument is not a valid hex color" do
        colors[0] = "FFFFFF"
        expect { Palette.new(colors) }.to raise_error(InvalidColorInput, "Input 'FFFFFF' not a valid hex color")
      end

      it "fails if the second argument is not a valid hex color" do
        colors[1] = "FFFFFF"
        expect { Palette.new(colors) }.to raise_error(InvalidColorInput, "Input 'FFFFFF' not a valid hex color")
      end

      it "fails if the last argument is not a valid hex color"  do
        colors[4] = "zzz"
        expect { Palette.new(colors) }.to raise_error(InvalidColorInput, "Input 'zzz' not a valid hex color")
      end
    end
  end

  describe "#colors" do
    let(:palette) { Palette.new(colors) }

    it "returns all colors" do
      expect(palette.colors).to eq colors
    end
  end
end

