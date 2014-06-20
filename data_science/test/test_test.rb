require 'minitest/autorun'
require_relative 'test_helper.rb'

class TestTest < MiniTest::Unit::TestCase

  def setup
    loader = DataLoader.new :json
    data = loader.read "test/fixtures/test_data.json"
    @test_a = Test.new(data, "A")
    @test_b = Test.new(data, "B")
  end

  def test_splits_data_correctly
    assert_equal "A", @test_a.cohort
    @test_a.data.each { |data| assert_equal "A", data[:cohort] }
    assert_equal 4,   @test_a.data.size

    assert_equal "B", @test_b.cohort
    @test_b.data.each { |data| assert_equal "B", data[:cohort] }
    assert_equal 3,   @test_b.data.size
  end

  def test_gets_correct_sample_size
    assert_equal 4, @test_a.sample_size
    assert_equal 3, @test_b.sample_size
  end

  def test_gets_correct_number_of_conversions
    assert_equal 3, @test_a.conversions
    assert_equal 1, @test_b.conversions
  end

  def test_gets_correct_percentage_of_conversion
    assert_in_delta 0.75, @test_a.conversion_rate, FLOAT_DELTA
    assert_in_delta 0.33333, @test_b.conversion_rate, FLOAT_DELTA
  end
  
  def test_gets_correct_error
    assert_in_delta 0.216506351, @test_a.standard_error, FLOAT_DELTA
    assert_in_delta 0.272165527, @test_b.standard_error, FLOAT_DELTA
  end

  def test_gets_correct_confidence_interval
    assert_in_delta 0.424352448, @test_a.confidence_interval, FLOAT_DELTA
    assert_in_delta 0.533444433, @test_b.confidence_interval, FLOAT_DELTA
  end

  def test_gets_correct_range
    a_range = (0.325647552..1.0)
    b_range = (0.0..0.866777766)

    assert_in_delta a_range.begin, @test_a.conversion_range.begin, FLOAT_DELTA
    assert_in_delta b_range.begin, @test_b.conversion_range.begin, FLOAT_DELTA

    assert_in_delta a_range.end, @test_a.conversion_range.end, FLOAT_DELTA
    assert_in_delta b_range.end, @test_b.conversion_range.end, FLOAT_DELTA
  end

end

