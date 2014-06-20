require 'minitest/autorun'
require_relative 'test_helper'

class DataLoaderTest < MiniTest::Unit::TestCase

  def setup
    @loader = DataLoader.new :json
  end

  def test_raises_error_if_not_json
    error = assert_raises(InvalidFormatError) { DataLoader.new :txt }
    assert_match  /Cannot read .txt. Accepted formats are \[:json\]/, 
                  error.message
  end

  def test_format_is_json
    assert_equal :json, @loader.format
  end

  def test_reads_json
    first_hash = {date: "2014-03-20", cohort: "B", result: 0}
    last_hash = {date: "2014-03-20", cohort: "A", result: 1}
    
    data = @loader.read("test/fixtures/test_data.json")

    assert_equal 7, data.size
    assert_includes data, first_hash
    assert_includes data, last_hash
  end

end

