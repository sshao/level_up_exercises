class InvalidColorInput < RuntimeError; end

class Palette < ActiveRecord::Base
  has_and_belongs_to_many :palette_sets
  serialize :colors, Array
  
  attr_accessor :colors, :image_url

  def initialize(new_colors, image_url = nil)
    raise InvalidColorInput, "No colors provided" if new_colors.size.zero?
    raise InvalidColorInput, "Too many colors provided" if new_colors.size > 5

    @image_url = image_url

    @colors = []

    new_colors.each do |color|
      raise InvalidColorInput, "Input '#{color}' not a valid hex color" unless valid_color?(color)
      @colors << format_color(color)
    end
  end

  private
  def valid_color?(color)
    color =~ /^#*[A-Fa-f0-9]{6}$|^#*[A-Fa-f0-9]{3}$/
  end

  def format_color(color)
    color.insert(0, '#') if color[0] != '#'
    color
  end
end

