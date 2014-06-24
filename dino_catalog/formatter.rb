class InvalidFormatError < RuntimeError; end

class Formatter
  FORMATTERS = { /genus,period,carnivore,weight,walking/i => "AfricanFormatter",
                 /name,period,continent,diet,weight_in_lbs,walking,description/i => "Formatter" }

  def format(hash_array)
    hash_array
  end

  # TODO this doesn't seem like it belongs in this class now 
  def self.formatter(body)
    formatter = FORMATTERS.find { |header, formatter| body.lines.first =~ header }
    raise InvalidFormatError, "Invalid CSV format" if formatter.nil?
    
    Object.const_get(formatter[1]).new
  end
end

class AfricanFormatter < Formatter
  AFRICAN_HEADER_MAPPINGS = { :genus => :name, :carnivore => :diet, :weight => :weight_in_lbs }
  
  def format(hash_array)
    hash_array.map { |record| reformat(record) }
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

