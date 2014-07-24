class WelcomeController < ApplicationController
  def index
    @palette_set = PaletteSet.all.sample
    @palette = @palette_set.try(:palettes).try(:sample)
  end
end
