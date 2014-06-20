require_relative 'split_tester_config'

class Test
  attr_reader :cohort, :data, :sample_size, :conversions

  def initialize(data, cohort)
    @cohort = cohort
    @data = data.select { |h| h[:cohort] == cohort }
    @sample_size = @data.size
    @conversions = @data.count { |h| h[:result] == 1 }
  end

  def conversion_rate
    @conversions.to_f / @sample_size.to_f
  end

  def standard_error
    p = conversion_rate
    Math.sqrt(p * (1 - p) / @sample_size)
  end

  def confidence_interval
    PERCENTILE_POINT_OF_95 * standard_error
  end

  def conversion_range
    interval = confidence_interval
    conversion_percentage = conversion_rate

    lower_bound = [0, conversion_percentage - interval].max
    upper_bound = [1, conversion_percentage + interval].min
    
    Range.new(lower_bound, upper_bound)
  end

end

