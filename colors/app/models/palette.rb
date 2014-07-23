class Palette < ActiveRecord::Base
  has_and_belongs_to_many :palette_sets, join_table: :palette_sets_palettes
  
  serialize :colors, Array
  attr_readonly :colors

  validates :image_url, presence: true

  before_save :generate_palette

  NUM_COLORS = 5

  private
  def generate_palette
    image = open_image(self.image_url)
    return false if image.nil?
    
    self.colors = quantized_colors(image)
  end

  def quantized_colors(image)
    quantized_image = image.quantize(5, Magick::RGBColorspace)
    hist = quantized_image.color_histogram
    hist.keys.map { |p| p.to_color(Magick::AllCompliance, false, 8, true) }
  end
  
  def open_image(url)
    Magick::ImageList.new(url).cur_image
  rescue Magick::ImageMagickError => e
    errors.add(:source, "could not open source image at #{url}: #{e.inspect}")
    nil
  end
end

