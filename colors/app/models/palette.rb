class Palette < ActiveRecord::Base
  has_and_belongs_to_many :palette_sets
  serialize :colors, Array

  validate :validate_colors

  after_initialize :format_colors
  
  attr_accessor :colors, :image_url

  private
  def validate_colors 
    errors.add(:colors, "No colors provided") if colors.size.zero?
    errors.add(:colors, "Too many colors provided") if colors.size > 5
    colors.each do |color|
      errors.add(:colors, "Input '#{color}' not a valid hex color") unless valid_color?(color)
    end
  end

  def valid_color?(color)
    color =~ /^#*[A-Fa-f0-9]{6}$|^#*[A-Fa-f0-9]{3}$/
  end

  def format_colors
    colors.each do |color|
      color.insert(0, '#') if color[0] != '#'
    end
  end
end

