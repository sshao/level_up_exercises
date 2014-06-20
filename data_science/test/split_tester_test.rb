require 'minitest/autorun'
require_relative 'test_helper.rb'

class SplitTesterTest < MiniTest::Unit::TestCase

  def setup
    loader = DataLoader.new :json
    @tester = SplitTester.new(loader.read "test/fixtures/test_data.json")
  end

  def test_fails_if_too_many_tests
    data = [{cohort: "A"}, {cohort: "B"}, {cohort: "C"}]
    error = assert_raises(WrongNumberOfTestsError) { SplitTester.new(data) }
    assert_match /Wrong number of tests \(3\). Try 2 tests/, error.message
  end

  def test_fails_if_too_few_tests
    data = [{cohort: "A"}]
    error = assert_raises(WrongNumberOfTestsError) { SplitTester.new(data) }
    assert_match /Wrong number of tests \(1\). Try 2 tests/, error.message
  end

  def test_identifies_correct_tests
    assert_equal 2, @tester.tests.size
  end

  def test_gets_correct_chi_square
    assert_in_delta 1.21527778, @tester.calculate_chi_square, FLOAT_DELTA
  end

  def test_gets_correct_chi_confidence_level
    assert_in_delta 0.72970908, @tester.calculate_chi_confidence, FLOAT_DELTA
  end

end

