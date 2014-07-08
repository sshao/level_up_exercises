class PaletteSetsController < ApplicationController
  def new
    @paletteset = PaletteSet.new(params[:tumblr_username])
  end

  def create
  end

  def update
  end

  def destroy
  end

  def index
  end

  def show
  end
end
