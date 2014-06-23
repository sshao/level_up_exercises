require 'statistics2'
require_relative 'test'

class WrongNumberOfTestsError < RuntimeError; end

class SplitTester
  attr_reader :tests

  def initialize(data)
    @data = data
    @tests = identify_tests

    raise WrongNumberOfTestsError, "Wrong number of tests (#{@tests.size}). Try 2 tests" unless @tests.size == 2 
  end

  # http://math.hws.edu/javamath/ryan/ChiSquare.html
  # see equation in section "2 x 2 contingency table"
  def chi_square
    a, b, c, d = contingency_values

    chi_square_numerator = (a * d - b * c) ** 2 * (a + b + c + d)
    chi_square_denominator = (a + b) * (c + d) * (b + d) * (a + c)

    chi_square_numerator.to_f / chi_square_denominator.to_f
  end
  
  def chi_confidence
    Statistics2.chi2dist(1, chi_square)
  end

  private
  def identify_tests
    test_hash = @data.group_by { |datum| datum[:cohort] }
    test_hash.map { |cohort, data| Test.new(data, cohort) }
  end

  def contingency_values
    [@tests[0].nonconversions, @tests[0].conversions,
     @tests[1].nonconversions, @tests[1].conversions]
  end

end

