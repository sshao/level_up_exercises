class InvalidFormatError < RuntimeError; end

module FormatterFactory
  FORMATTERS = { "genus,period,carnivore,weight,walking" => "AfricanFormatter",
                 "name,period,continent,diet,weight_in_lbs,walking,description" => "DinodexFormatter" }

  def self.formatter(raw_data)
    formatter_class = FORMATTERS[header_str(raw_data)]
    raise InvalidFormatError, "Invalid CSV format" if formatter_class.nil?

    Object.const_get(formatter_class).new(raw_data)
  end

  private
  def self.header_str(raw_data)
    raw_data.lines.first.downcase.chomp
  end
end

class Formatter
  attr_reader :dino_hashes

  def initialize(body)
    csv = CSV(body, headers: true, header_converters: header_conversions.flatten,
                  converters: body_conversions.flatten)
    @dino_hashes = csv.map(&:to_hash)
  end

  def format
    @dino_hashes
  end

  private
  def header_conversions
    [:symbol]
  end

  def body_conversions
    [:downcase, :all]
  end

  CSV::Converters[:downcase] = lambda do |body, field_info|
    body.downcase unless body.nil?
  end
end

class DinodexFormatter < Formatter
end

class AfricanFormatter < Formatter
  HEADER_MAPPINGS = { "genus" => :name, "carnivore" => :diet, "weight" => :weight_in_lbs }
  DIET_MAPPINGS = { "yes" => "carnivore", "no" => "herbivore" }

  def format
    @dino_hashes.each { |dino_hash| add_continent(dino_hash) }
  end

  private
  def header_conversions
    [:downcase, :standardize_header, super]
  end

  def body_conversions
    [super, :standardize_diet]
  end

  def add_continent(dino_hash)
    dino_hash[:continent] = "africa"
  end

  CSV::HeaderConverters[:standardize_header] = lambda do |header|
    HEADER_MAPPINGS[header] || header
  end

  CSV::Converters[:standardize_diet] = lambda do |body, field_info|
    field_info.header == :diet ? DIET_MAPPINGS[body] : body
  end
end
