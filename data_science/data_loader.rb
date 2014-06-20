require 'json'
require_relative 'data_loader_config'

class InvalidFormatError < RuntimeError; end

class DataLoader

  attr_accessor :format

  def initialize(format)
    raise InvalidFormatError, "Cannot read .#{format}. Accepted formats are #{ACCEPTED_FORMATS}" unless ACCEPTED_FORMATS.include? format

    @format = format
  end

  def read(filepath)
    method = "read_#{@format}"
    send(method, *[filepath]) if self.respond_to? method, true
  end

  private
  def read_json(filepath)
    string = File.read(filepath)
    JSON.parse(string, :symbolize_names => true)
  end

end

