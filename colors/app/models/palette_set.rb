require 'rmagick'

class PaletteSet < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :palettes

  attr_reader :palettes

  POST_LIMIT = 10

  def initialize(blog) 
    @client = Tumblr::Client.new
    @response = @client.posts("#{blog}.tumblr.com", :type => "photo", :limit => POST_LIMIT)

    # FIXME check response
    
    @palettes = @response["posts"].map { |post| generate_palette(post) }
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
    Palette.new(sorted, image_url)
  end
end

