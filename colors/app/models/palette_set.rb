require 'rmagick'

class PaletteSet < ActiveRecord::Base
  has_and_belongs_to_many :palettes, join_table: :palette_sets_palettes
  belongs_to :user

  validates :source, presence: true, uniqueness: true
  validate :source_exists
  before_save :generate_palettes

  def source_exists
    client = Tumblr::Client.new
    response = client.blog_info("#{source}.tumblr.com")
    errors.add(:source, "not found, returned 404") if response["status"] == 404
  end

  def generate_palettes
    # FIXME open for each instance of PaletteSet? Or have one open for whole app?
    @client = Tumblr::Client.new

    # FIXME check response for valid response
    response = @client.posts("#{source}.tumblr.com", :type => "photo", :limit => PULL_LIMIT)

    if response["status"].nil?
      response["posts"].each { |post| generate_palette(post) }
    else
      errors.add(:source, "did not receive successful response, got #{response["status"]}")
      return false
    end
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
    image = open_image(image_url)

    return if image.nil?

    quantized_img = image.quantize(5, Magick::RGBColorspace)
    quantized_colors = get_quantized_colors(quantized_img)

    # TODO check palette is valid
    palette = Palette.new(colors: quantized_colors, image_url: image_url)
    palettes << palette if palette.save

    # TODO will save palettes without saving palette_set...
    # is that what i want? or only when encompassing palette_set is
    # successfully saved?
  end

  def open_image(url)
    Magick::ImageList.new(url).cur_image
  rescue Magick::ImageMagickError => e
    logger.error e.inspect
    return nil
  end

  def get_quantized_colors(image)
    hist = image.color_histogram
    hist.keys.map { |p| p.to_color(Magick::AllCompliance, false, 8, true) }
  end
end

