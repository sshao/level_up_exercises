class PaletteSet < ActiveRecord::Base
  has_and_belongs_to_many :palettes, join_table: :palette_sets_palettes
  has_and_belongs_to_many :users, join_table: :palette_sets_users

  validates :source, presence: true, uniqueness: true
  validate :source_exists

  before_create :generate_palettes

  def tumblr_url(username)
    "#{username}.tumblr.com"
  end

  def source_exists
    @client ||= Tumblr::Client.new
    response = @client.blog_info(tumblr_url(source))
    errors.add(:source, "not found, returned 404") if response["status"] == 404
  end

  def generate_palettes
    response = @client.posts(tumblr_url(source), :type => "photo", :limit => PULL_LIMIT)

    # TODO move into its own validator? or somehow refactor into something
    # that makes more sense
    errors.add(:source, "did not receive successful response, got #{response["status"]}") unless response["status"].nil?
    return false unless response["status"].nil?

    response["posts"].each { |post| generate_palette(post) }
  end

  private
  def image_url(post)
    images = post["photos"].first
    image = standard_size(images) || original_size(images)
    image["url"]
  end

  def standard_size(image)
    image["alt_sizes"].find { |photo| photo["width"] == 500 }
  end

  def original_size(image)
    image["original_size"]
  end

  def generate_palette(post)
    image_url = image_url(post)
    image = open_image(image_url)

    return if image.nil?

    palette = Palette.new(colors: colors(image), image_url: image_url)
    palettes << palette if palette.save
  end

  def open_image(url)
    Magick::ImageList.new(url).cur_image
  rescue Magick::ImageMagickError => e
    errors.add(:source, "could not open source image at #{url}: #{e.inspect}")
    nil
  end

  # FIXME move into Palette Model -- have PaletteSet pass in URL to Palette.new
  def colors(image)
    quantized_image = image.quantize(5, Magick::RGBColorspace)
    hist = quantized_image.color_histogram
    hist.keys.map { |p| p.to_color(Magick::AllCompliance, false, 8, true) }
  end
end

