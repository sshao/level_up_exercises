require 'rmagick'

class PaletteSet < ActiveRecord::Base
  has_and_belongs_to_many :palettes, join_table: :palette_sets_palettes
  belongs_to :user

  before_save :generate_palettes

  POST_LIMIT = 10

  def generate_palettes
    # FIXME open for each instance of PaletteSet? Or have one open for whole app?
    @client = Tumblr::Client.new

    # FIXME check response for valid response
    response = @client.posts("#{source}.tumblr.com", :type => "photo", :limit => POST_LIMIT)

    response["posts"].each { |post| generate_palette(post) }
  end

  private
  def photo_url(post)
    # FIXME gracefully deal with photosets 
    post["photos"][0]["alt_sizes"][0]["url"]
  end

  def generate_palette(post)
    # FIXME stub? 
    image_url = photo_url(post)
    image = Magick::ImageList.new(image_url).cur_image
    quantized_img = image.quantize(5, Magick::RGBColorspace)
    hist = quantized_img.color_histogram
    sorted = hist.keys.sort_by { |p| -hist[p] }
    sorted = sorted.collect { |p| p.to_color(Magick::AllCompliance, false, 8, true) }
    # TODO will save palettes without saving paletteset...
    # is that what i want?
    # or should i only save palettes when i save encompassing paletteset?
    palettes << Palette.create(colors: sorted, image_url: image_url)
  end
end

