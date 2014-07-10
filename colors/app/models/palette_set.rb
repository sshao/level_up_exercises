require 'rmagick'

class PaletteSet < ActiveRecord::Base
  has_and_belongs_to_many :palettes, join_table: :palette_sets_palettes
  belongs_to :user

  before_save :generate_palettes

  def generate_palettes
    # FIXME open for each instance of PaletteSet? Or have one open for whole app?
    @client = Tumblr::Client.new

    # FIXME check response for valid response
    response = @client.posts("#{source}.tumblr.com", :type => "photo", :limit => PULL_LIMIT)

    response["posts"].each { |post| generate_palette(post) }
  end

  private
  def photo_url(post)
    # FIXME gracefully deal with photosets 
    first_photo = post["photos"][0]
    photo_500px = first_photo["alt_sizes"].find{ |photo| photo["width"] == 500 } || first_photo["original_size"]
    photo_500px["url"]
  end

  def generate_palette(post)
    image_url = photo_url(post)
    image = Magick::ImageList.new(image_url).cur_image

    quantized_img = image.quantize(5, Magick::RGBColorspace)
    quantized_colors = get_quantized_colors(quantized_img)

    # TODO check palette is valid
    palette = Palette.create(colors: quantized_colors, image_url: image_url)

    # TODO will save palettes without saving paletteset...
    # is that what i want?
    # or should i only save palettes when i save encompassing paletteset?
    
    palettes << palette
  end

  def get_quantized_colors(image)
    hist = image.color_histogram
    hist.keys.map { |p| p.to_color(Magick::AllCompliance, false, 8, true) }
  end
end

