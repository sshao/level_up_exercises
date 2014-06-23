require 'json'

class InvalidFormatError < RuntimeError; end

class DataLoader

  # TODO yaml?
  ACCEPTED_FORMATS = [:json]

  attr_accessor :format

  def initialize(format)
    unless ACCEPTED_FORMATS.include? format
      raise InvalidFormatError, "Cannot read .#{format}. Accepted formats are #{ACCEPTED_FORMATS}" 
    end

    @format = format
  end

  def read(filepath)
    method = "read_#{@format}"
    send(method, filepath) if self.respond_to?(method, true)
  end

  private
  def read_json(filepath)
    string = File.read(filepath)
    JSON.parse(string, :symbolize_names => true)
  end

end

