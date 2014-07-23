class PaletteSetsController < ApplicationController
  respond_to :html

  def create
    palette_set = fetch_or_return(palette_set_params)

    flash[:error] = palette_set.errors.full_messages
    # FIXME move into view
    flash[:alert] = "No photo posts found to generate palettes from" if palette_set.palettes.empty?

    respond_with(palette_set)
  end

  # FIXME look at scopes (recent, popular)
  def index
    @palette_sets = PaletteSet.all
  end

  def show
    @palette_set = PaletteSet.find(params[:id])
  end

  private
  def palette_set_params
    params.fetch(:palette_set, {}).permit(:source)
  end

  def fetch_or_return(args)
    PaletteSet.find_by(args) || PaletteSet.create(args)
  end
end

