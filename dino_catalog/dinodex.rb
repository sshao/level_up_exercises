require 'csv'
require_relative 'formatter'
require_relative 'dinodex_config'

class DinodexMatchError < RuntimeError; end
class InvalidWeightError < DinodexMatchError; end

class Dinodex
  attr_accessor :dinos
 
  def initialize(filepaths = nil)
    @dinos = []
    @dino_objects = []
    # TODO could probably refactor further 
    filepaths = Array(filepaths)
    filepaths.each { |path| @dinos += Array(records(path)) }
    filepaths.each { |path| @dino_objects += Array(create_dino(path)) }
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

  def size
    @dinos.size
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
    Dino.new(dino).to_s
  end

  def create_dino(path)
    records(path).each { |record| Dino.new(record) }
  end

  def records(path)
    body = read_file(path)
    return if body.nil?

    formatter_class = formatter(body.lines.first)
    return if formatter_class.nil?

    formatter = formatter_class.new(body)
    formatter.format
  end

  def read_file(path)
    File.read(path).downcase
  rescue Errno::ENOENT
    puts "File #{path} not found, skipping"
  end

  def formatter(header)
    FormatterFactory.formatter(header)
  rescue InvalidFormatError => e
    puts e.inspect
  end

  def matches?(dino, search)
    key = search.keys.first
    target = search[key]

    method_name = "matches_#{key.to_s}?"

    if self.respond_to? method_name, true
      send(method_name, *[dino, target])
    else
      matches_arbitrary_target?(dino, key, target)
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
    dino[:weight_in_lbs] > BIG_DINO_WEIGHT_THRESHOLD
  end

  def is_small_dino?(dino)
    !is_big_dino?(dino)
  end

end

class Dino
  attr_reader :name, :period, :continent, :diet, :weight_in_lbs, :walking, :description

  def initialize(record)
    record.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def to_s
    instance_variables.map do |instance_variable|
      fact = instance_variable_get(instance_variable)
      unless fact.nil?
        "#{instance_variable}: #{fact}\n"
      end
    end.join
  end



end
