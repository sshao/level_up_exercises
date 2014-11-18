require 'csv'
require_relative 'formatter'
require_relative 'dino'

class Dinodex
  attr_accessor :dinos

  def initialize(filepaths = nil, dinos = [])
    @dinos = dinos

    # TODO could probably refactor further
    filepaths = Array(filepaths)
    filepaths.each { |path| @dinos += Array(create_dino(path)) }
  end

  def find(search)
    Dinodex.new(nil, @dinos.select { |dino| dino.matches? (search) })
  end

  def size
    @dinos.size
  end

  def to_s
    @dinos.map { |dino| dino.to_s }.join
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
  end
end
