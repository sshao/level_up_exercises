require 'csv'
require_relative 'formatter'
require_relative 'dinodex_config'

# FIXME have more specific error names -- possibly create different error classes
class DinodexError < RuntimeError; end

class Dinodex
  attr_accessor :dinos
 
  def initialize(filepaths = nil)
    @dinos = []
    Array(filepaths).each { |path| @dinos += create_entries(path) } if filepaths
  end

  def add(dino_hash)
    @dinos += Array(dino_hash)
  end

  def find(search)
    results_dinodex = Dinodex.new
    results_dinodex.add(@dinos.select { |dino| matches?(dino, search) })

    results_dinodex
  end

  def to_s(name = nil)
    if name
      dino = @dinos.find { |dino| dino[:name] == name.downcase }
      dino_to_s(dino)
    else
      str = ""
      @dinos.each { |dino| str << dino_to_s(dino) }
      str
    end
  end

  private
  def dino_to_s(dino)
    str = ""
    dino.each { |header, fact| str << "#{header}: #{fact}\n" unless fact.nil? }
    str
  end

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

