class PaletteSetsController < ApplicationController
  def new
  end

  def create
    palette_set = PaletteSet.new(permitted_params)

    if palette_set.save
      flash[:alert] = "No photo posts found to generate palettes from" if palette_set.palettes.empty?
      redirect_to palette_set
    elsif palette_set.errors.full_messages.include? "Source has already been taken"
      redirect_to PaletteSet.find_by(permitted_params)
    else
      flash[:error] = palette_set.errors.full_messages
      redirect_to action: :index
    end
  end

  def update
  end

  def destroy
  end

  def index
    @palette_sets = PaletteSet.all
  end

  def show
    @palette_set = PaletteSet.find(params[:id])
  end

  def permitted_params
    params.fetch(:palette_set, {}).permit(:source)
  end
end

