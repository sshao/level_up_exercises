module PaletteSetsHelper
  def user_area(&block)
    yield if user_signed_in?
  end

  def tumblr_url(source)
    "http://#{source}.tumblr.com"
  end

  def favorite_button(disabled)
    button_params = { true => { state: "Favorited", classes: "button tiny round disabled" },
      false => { state: "Favorite", classes: "button tiny round" } }

    yield(button_params[disabled][:state], button_params[disabled][:classes], disabled)
  end
end
