class InvalidFormatError < RuntimeError; end

module FormatterFactory
  FORMATTERS = { /genus,period,carnivore,weight,walking/i => "AfricanFormatter",
                 /name,period,continent,diet,weight_in_lbs,walking,description/i => "DinodexFormatter" }


  def self.formatter(body)
    formatter = FORMATTERS.find { |header, formatter| body.lines.first =~ header }
    raise InvalidFormatError, "Invalid CSV format" if formatter.nil?
    Object.const_get(formatter[1])
  end
end

class Formatter
  attr_reader :csv_hash

  def initialize(body)
    csv = CSV.new(body, :headers => true, :header_converters => :symbol,
                  :converters => :all)
    @csv_hash = csv.map(&:to_hash)
  end
end

class DinodexFormatter < Formatter

  def format
    @csv_hash
  end

end

class AfricanFormatter < Formatter
  AFRICAN_HEADER_MAPPINGS = { :genus => :name, :carnivore => :diet, :weight => :weight_in_lbs }

  def format
    @csv_hash.map { |record| reformat(record) }
  end

  private
  def reformat(hash)
    hash[:continent] = "africa"
    hash[:carnivore] = get_diet(hash[:carnivore])

    Hash[hash.map { |k, v| [AFRICAN_HEADER_MAPPINGS[k] || k, v] }]
  end

  def get_diet(is_carnivore)
    case is_carnivore
    when "yes" then "carnivore"
    when "no" then "herbivore"
    else nil
    end
  end
end
