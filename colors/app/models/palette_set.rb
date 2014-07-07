require 'rmagick'

class PaletteSet < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :palettes

  attr_accessor :palettes

  POST_LIMIT = 10

  def initialize(blog) 
    @client = Tumblr::Client.new(:client => :httpclient)
    @response = @client.posts("#{blog}.tumblr.com", :type => "photo", :limit => POST_LIMIT)

    generate_palettes
  end

  private
  def generate_palettes
    @response["posts"].each do |post|
      # FIXME deal gracefully with photosets
      # FIXME pick a photo size other than first/original size ... since we're quantizing
      # it shouldn't have to be that big, but it also can't be the smallest (75px width)
      photo_url = post["photos"][0]["alt_sizes"][0]["url"]
      @palettes << generate_palette(photo_url)
    end
  end

  def generate_palette(url)
    # FIXME stub? 
    image = Magick::ImageList.new(url).cur_image
    quantized_img = image.quantize(5, Magick::RGBColorspace)
    hist = quantized_img.color_histogram
    sorted = hist.keys.sort_by { |p| -hist[p] }
    sorted = sorted.collect { |p| p.to_color(Magick::AllCompliance, false, 8, true) }
    Palette.new(sorted)
  end
end
