class Test
  attr_reader :cohort, :data, :sample_size, :conversions, :nonconversions
  
  PERCENTILE_POINT_OF_95 = 1.96

  def initialize(data, cohort)
    @cohort = cohort
    @data = data
    @sample_size = data.size
    @conversions = data.count { |h| h[:result] == 1 }
    @nonconversions = sample_size - conversions
  end

  def conversion_rate
    @conversion_rate ||= conversions.to_f / sample_size.to_f
  end

  def standard_error
    p = conversion_rate
    Math.sqrt(p * (1 - p) / sample_size)
  end

  def confidence_interval
    @confidence_interval ||= PERCENTILE_POINT_OF_95 * standard_error
  end

  def conversion_range
    lower_bound = [0, conversion_rate - confidence_interval].max
    upper_bound = [1, conversion_rate + confidence_interval].min

    (lower_bound..upper_bound)
  end

end

