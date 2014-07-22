class UsersController < ApplicationController
  def favorite
    palette_set = PaletteSet.find(params[:id])
    current_user.palette_sets << palette_set
    current_user.save
    redirect_to palette_set
  end

  def show
  end
end
