class InvalidColorInput < RuntimeError; end

class Palette < ActiveRecord::Base
  has_and_belongs_to_many :palette_sets
  serialize :colors, Array
  
  attr_accessor :colors

  def initialize(new_colors)
    raise InvalidColorInput, "No colors provided" if new_colors.size.zero?
    raise InvalidColorInput, "Too many colors provided" if new_colors.size > 5

    @colors = []

    new_colors.each do |color|
      raise InvalidColorInput, "Input '#{color}' not a valid hex color" unless valid_color?(color)
      @colors << color
    end
  end

  private
  def valid_color?(color)
    color =~ /^#[A-Fa-f0-9]{6}$|^[A-Fa-f0-9]{3}$/
  end
end

