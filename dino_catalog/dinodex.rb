require 'csv'
require_relative 'formatter'
require_relative 'dinodex_config'

class DinodexMatchError < RuntimeError; end
class InvalidWeightError < DinodexMatchError; end

class Dinodex
  attr_accessor :dinos
 
  def initialize(filepaths = nil)
    @dinos = []
    # TODO could probably refactor further 
    filepaths = Array(filepaths)
    filepaths.each { |path| @dinos += Array(records(path)) }
  end

  def add(dino)
    @dinos << dino
  end

  def find(search)
    # TODO Dinodex.create_from( matching = @dinos.select { search } ) ?
    results_dinodex = Dinodex.new
    @dinos.select { |dino| results_dinodex.add(dino) if matches?(dino, search) }
    results_dinodex
  rescue DinodexMatchError => e
    puts e.inspect
  end

  def to_s
    @dinos.map { |dino| dino_to_s(dino) }.join
  end

  def print_dino(name)
    dino = @dinos.find { |dino| dino[:name] == name.downcase }
    dino_to_s(dino)
  end

  private
  def dino_to_s(dino)
    dino.map { |header, fact| "#{header}: #{fact}\n" unless fact.nil? }.join
  end

  def records(path)
    body = read_file(path)
    return if body.nil?

    formatter = formatter(body.lines.first)
    return if formatter.nil?
    
    formatter.format(records_hash(body)) 
  end

  def read_file(path)
    File.read(path).downcase
  rescue Errno::ENOENT
    puts "File #{path} not found, skipping"
  end

  def formatter(header)
    formatter = Formatter.formatter(header)
  rescue InvalidFormatError => e
    puts e.inspect
  end

  def records_hash(body)
    csv = CSV.new(body, :headers => true, :header_converters => :symbol,
                  :converters => :all)
    csv_hash = csv.map(&:to_hash)
  end

  def matches?(dino, search)
    target = search[:target].downcase

    method_name = "matches_#{search[:key].to_s}?"
    
    if self.respond_to? method_name, true 
      send(method_name, *[dino, target])
    else
      matches_arbitrary_target?(dino, search[:key], target)
    end
  end

  def matches_arbitrary_target?(dino, key, target)
    dino[key].to_s.include? target
  end

  def matches_diet?(dino, target_diet)
    if target_diet == "carnivore"
      CARNIVORES.include?(dino[:diet])
    else
      dino[:diet].to_s == target_diet
    end
  end

  def matches_weight_in_lbs?(dino, weight)
    method_name = "is_#{weight}_dino?"

    if self.respond_to? method_name, true
      dino[:weight_in_lbs] && send(method_name, dino) 
    else
      raise InvalidWeightError, "Cannot find dinosaurs of weight #{weight}. Try 'big' or 'small' instead"
    end
  end

  def is_big_dino?(dino)
    dino[:weight_in_lbs] >= BIG_DINO_WEIGHT_THRESHOLD
  end

  def is_small_dino?(dino)
    !is_big_dino?(dino)
  end

end

