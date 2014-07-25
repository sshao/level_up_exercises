class WelcomeController < ApplicationController
  def index
    @random_palette_set = PaletteSet.all.sample
    @random_palette = @random_palette_set.try(:palettes).try(:sample)
  end
end
