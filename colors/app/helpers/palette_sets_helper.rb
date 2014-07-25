module PaletteSetsHelper
  def tumblr_url(source)
    "http://#{source}.tumblr.com"
  end

  def favorite_button(disabled)
    button_params = { true => { state: "Favorited", classes: "button tiny round disabled" },
      false => { state: "Favorite", classes: "button tiny round" } }

    yield(button_params[disabled][:state], button_params[disabled][:classes], disabled)
  end

  def palette_set_div(palette_set)
    background = palette_set.palettes.sample.image_url unless palette_set.palettes.blank?
    yield(background)
  end
end
