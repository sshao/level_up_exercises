require 'csv'
require_relative 'formatter'
require_relative 'dinodex_config'

# FIXME have more specific error names -- possibly create different error classes
class DinodexError < RuntimeError; end

class Dinodex
  attr_reader :dinos
 
  def initialize(filepaths)
    @dinos = []
    Array(filepaths).each { |path| @dinos += create_entries(path) }
  end

  # FIXME input searches as a hash
  #       allow chained searches, would have to return Dinodex rather than dino 
  #       names, or return a new instance of dinodex to allow chaining 
  def find(*searches)
    results = @dinos.select { |dino| matches_all?(dino, *searches) }
    results.map { |dino| dino[:name] }
  end

  # TODO override to_s (no args) method?

  def to_s(names)
    str = ""
    names_array = Array(names).map(&:downcase)

    names_array.each do |name|
      dino = @dinos.find { |dino| dino[:name] == name }
      dino.each { |header, fact| str << "#{header}: #{fact}\n" unless fact.nil? }
    end

    str
  end

  private
  # FIXME split into further methods
  def create_entries(path)
    body = File.read(path).downcase

    format = Formatter.identify_format(body)
    raise DinodexError, "Invalid CSV headers/format in #{path}" if format.nil?
      
    csv = CSV.new(body, :headers => true, :header_converters => :symbol,
                  :converters => :all)
      
    csv_hash = csv.to_a.map(&:to_hash)
    csv_hash = AfricanFormatter.format(csv_hash) if format == :african

    csv_hash 
  end

  # TODO use respond_to/define_method/send to decide on matches_? methods to use
  def matches_all?(dino, *searches)
    searches.all? { |search| matches?(dino, search) }
  end

  def matches?(dino, search)
    target = search[:target].downcase

    case search[:key]
    when :weight_in_lbs then matches_weight?(dino, target)
    when :diet then matches_diet?(dino, target)
    else matches_arbitrary_target?(dino, search[:key], target)
    end
  end

  def matches_arbitrary_target?(dino, key, target)
    dino[key].to_s.include? target
  end

  def matches_diet?(dino, target_diet)
    dino[:diet].to_s == target_diet || 
      (target_diet == "carnivore" && CARNIVORES.include?(dino[:diet]))
  end

  # FIXME error on weight != big||small
  def matches_weight?(dino, weight)
    dino[:weight_in_lbs] && 
    ((weight == "big" && is_big_dino?(dino)) || 
    (weight == "small" && is_small_dino?(dino)))
  end

  def is_big_dino?(dino)
    dino[:weight_in_lbs] >= 2000
  end

  def is_small_dino?(dino)
    !is_big_dino?(dino)
  end

end

