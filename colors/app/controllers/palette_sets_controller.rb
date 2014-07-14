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
      if @palette_set.errors.full_messages.include? "Source has already been taken"
        redirect_to PaletteSet.find_by(source: params[:palette_set][:tumblr_username])
      else
        flash[:error] = @palette_set.errors.full_messages
        redirect_to action: "index"
      end
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
end

