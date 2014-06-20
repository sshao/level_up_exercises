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
  def calculate_chi_square
    a, b, c, d = get_contingency_values

    chi_square_numerator = (a * d - b * c) ** 2 * (a + b + c + d)
    chi_square_denominator = (a + b) * (c + d) * (b + d) * (a + c)

    chi_square_numerator.to_f / chi_square_denominator.to_f
  end

  def calculate_chi_confidence
    Statistics2.chi2dist(1, calculate_chi_square)
  end

  private
  def identify_tests
    cohorts = @data.map { |h| h[:cohort] }.uniq
    cohorts.map { |cohort| Test.new(@data, cohort) }
  end

  def get_contingency_values
    return  @tests.first.sample_size - @tests.first.conversions,
            @tests.first.conversions,
            @tests.last.sample_size - @tests.last.conversions,
            @tests.last.conversions
  end

end

