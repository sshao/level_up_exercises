class InvalidFormatError < RuntimeError; end

module FormatterFactory
  FORMATTERS = { "genus,period,carnivore,weight,walking" => "AfricanFormatter",
                 "name,period,continent,diet,weight_in_lbs,walking,description" => "DinodexFormatter" }

  def self.formatter(body)
    header_str = body.lines.first.downcase.chomp
    formatter_class = FORMATTERS[header_str]
    raise InvalidFormatError, "Invalid CSV format" if formatter_class.nil?
    Object.const_get(formatter_class).new(body)
  end
end

class Formatter
  attr_reader :csv_hash

  def initialize(body)
    csv = CSV.new(body, headers: true, header_converters: header_conversions,
                  converters: body_conversions)
    @csv_hash = csv.map(&:to_hash)
  end

  def format
    @csv_hash
  end

  private
  def header_conversions
    [:symbol]
  end

  def body_conversions
    [:all]
  end
end

class DinodexFormatter < Formatter
end

class AfricanFormatter < Formatter
  HEADER_MAPPINGS = { genus: :name, carnivore: :diet, weight: :weight_in_lbs }
  DIET_MAPPINGS = { "yes" => "carnivore", "no" => "herbivore" }

  CSV::HeaderConverters[:standardize_header] = lambda do |header|
    HEADER_MAPPINGS[header.to_sym] || header
  end

  CSV::Converters[:standardize_diet] = lambda do |body, field_info|
    field_info.header == :diet ? DIET_MAPPINGS[body] : body
  end

  def format
    @csv_hash.map { |dino_hash| reformat(dino_hash) }
  end

  private
  def header_conversions
    [:standardize_header, :symbol]
  end

  def body_conversions
    [:standardize_diet, :all]
  end

  def reformat(dino_hash)
    dino_hash[:continent] = "africa"
    dino_hash
  end
end
