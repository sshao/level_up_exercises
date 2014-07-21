class Palette < ActiveRecord::Base
  has_and_belongs_to_many :palette_sets, join_table: :palette_sets_palettes
  
  serialize :colors, Array

  validates :image_url, presence: true
  validate :validate_colors_present, :validate_five_colors_at_most, 
    :validate_colors_valid

  before_save :format_colors

  NUM_COLORS = 5

  def validate_colors_present
    errors.add(:colors, "No colors provided") if colors.size.zero?
  end

  def validate_five_colors_at_most
    errors.add(:colors, "Too many colors provided") if colors.size > NUM_COLORS
  end
  
  def validate_colors_valid
    colors.each do |color|
      errors.add(:colors, "Input '#{color}' not a valid hex color") unless valid_color?(color)
    end
  end

  def valid_color?(color)
    color =~ /^#*[A-F0-9]{6}$|^#*[A-F0-9]{3}$/i
  end

  def format_colors
    colors.each { |color| color.insert(0, '#') if color[0] != '#' }
  end
end

