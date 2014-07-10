class PaletteSetsController < ApplicationController
  def new
  end

  def create
    @palette_set = PaletteSet.new(source: params[:palette_set][:tumblr_username])
    if @palette_set.save
      redirect_to @palette_set
    else
      render action: :index
    end
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
