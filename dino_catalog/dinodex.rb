require 'csv'
require_relative 'formatter'
require_relative 'dinodex_config'

class Dinodex
  attr_accessor :dinos
 
  def initialize(filepaths = nil)
    @dinos = []
    Array(filepaths).each { |path| @dinos += Array(create_entries(path)) } if filepaths
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

  def create_entries(path)
    body, formatter = read_csv(path) 

    if formatter
      csv = CSV.new(body, :headers => true, :header_converters => :symbol,
                    :converters => :all)
      csv_hash = csv.to_a.map(&:to_hash)

      formatter.format(csv_hash) 
    end
  end

  def read_csv(path)
    begin
      body = File.read(path).downcase
      format = Formatter.identify_format(body)
    rescue RuntimeError => e
      puts "#{e.inspect} -- from file #{path}"
    end

    return body, format
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
    dino[:diet].to_s == target_diet || 
      (target_diet == "carnivore" && CARNIVORES.include?(dino[:diet]))
  end

  # FIXME error on weight != big||small
  def matches_weight_in_lbs?(dino, weight)
    method_name = "is_#{weight}_dino?"

    dino[:weight_in_lbs] && send(method_name, dino) if self.respond_to? method_name, true
  end

  def is_big_dino?(dino)
    dino[:weight_in_lbs] >= BIG_DINO_WEIGHT_THRESHOLD
  end

  def is_small_dino?(dino)
    !is_big_dino?(dino)
  end

end

