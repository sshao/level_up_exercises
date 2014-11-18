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
    if dino.is_a? Dino
      @dino_objects << dino
    else
      @dinos << dino
    end
  end

  def find(search)
    # TODO Dinodex.create_from( matching = @dinos.select { search } ) ?
    results_dinodex = Dinodex.new
    results_dinodex_objs = Dinodex.new
    @dino_objects.select { |dino| results_dinodex_objs.add(dino) if matches?({}, dino, search) }
    @dinos.select { |dino| results_dinodex.add(dino) if matches?(dino, nil, search) }
    results_dinodex_objs
  end

  def size
    if @dinos.empty?
      @dino_objects.size
    else
      @dinos.size
    end
  end

  def to_s
    relevant_dinos = @dinos.empty? ? @dino_objects : @dinos
    relevant_dinos.map do |dino|
      if dino.is_a? Dino
        dino.to_s
      else
        Dino.new(dino).to_s
      end
    end.join
  end

  def print_dino(name)
    dino = @dinos.find { |dino| dino[:name] == name.downcase }
    Dino.new(dino).to_s
  end

  private
  def create_dino(path)
    records(path).map { |record| Dino.new(record) }
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

  # dino = { :name => sdf, :continent => .. }
  # search = { name: "sdf" }
  def matches?(dino, dinoobj, search)
    if dino.empty?
      dino_obj = dinoobj
    else
      dino_obj = Dino.new(dino)
    end

    key = search.keys.first
    target = search[key]

    method_name = "matches_#{key.to_s}?"

    if self.respond_to? method_name, true
      send(method_name, *[dino_obj, target])
    else
      matches_arbitrary_target?(dino_obj, key, target)
    end
  end

  def matches_arbitrary_target?(dino_obj, key, target)
    return false if dino_obj.instance_variable_get("@#{key}").nil?
    dino_obj.instance_variable_get("@#{key}").include? target
  end

  def matches_diet?(dino_obj, target_diet)
    dino_obj.matches_diet?(target_diet)
  end

  # dino = dino hash
  # weight = "big", "small"
  def matches_weight_in_lbs?(dino_obj, weight)
    dino_obj.matches_weight_in_lbs?(weight)
  rescue NoMethodError
    raise InvalidWeightError, "Cannot find dinosaurs of weight #{weight}. Try 'big' or 'small' instead"
  end
end

class Dino
  attr_reader :name, :period, :continent, :diet, :weight_in_lbs, :walking, :description

  def initialize(record)
    record.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def matches_diet?(target_diet)
    if target_diet == "carnivore"
      CARNIVORES.include?(@diet)
    else
      @diet == target_diet
    end
  end

  def matches_weight_in_lbs?(weight)
    method_name = "is_#{weight}?"
    send(method_name)
  end

  def is_big?
    return false if @weight_in_lbs.nil?
    @weight_in_lbs > BIG_DINO_WEIGHT_THRESHOLD
  end

  def is_small?
    return false if @weight_in_lbs.nil?
    !is_big?
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
