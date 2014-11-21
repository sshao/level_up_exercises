require 'csv'
require_relative 'formatter'
require_relative 'dino'

class Dinodex
  attr_accessor :dinos, :filepaths

  def initialize(filepaths = nil, dinos = [])
    @dinos = dinos

    @filepaths = Array(filepaths)
    create_dinos
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
  def create_dinos
    hashes = filepaths.map { |path| dino_hashes(path) }.flatten

    @dinos += hashes.map { |dino_hash| Dino.new(dino_hash) }
  end

  def dino_hashes(path)
    body = read_file(path)
    # TODO write spec for below
    return [] if body.nil?

    formatter = FormatterFactory.formatter(body)
    formatter.format
  end

  def read_file(path)
    File.read(path).downcase
  rescue Errno::ENOENT
    puts "File #{path} not found, skipping"
  end
end
