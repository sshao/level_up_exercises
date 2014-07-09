class PaletteSetsController < ApplicationController
  def new
  end

  def create
    @palette_set = PaletteSet.create(source: params[:palette_set][:tumblr_username])
    redirect_to @palette_set
  end

  def update
  end

  def destroy
  end

  def index
  end

  def show
    @palette_set = PaletteSet.find(params[:id])
  end
end
