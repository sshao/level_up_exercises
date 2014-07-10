class PaletteSetsController < ApplicationController
  def new
  end

  def create
    @palette_set = PaletteSet.new(source: params[:palette_set][:tumblr_username])
    if @palette_set.save
      if @palette_set.palettes.empty?
        flash[:alert] = "No photo posts found to generate palettes from"
      end
      redirect_to @palette_set
    else
      flash[:error] = @palette_set.errors.full_messages
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

