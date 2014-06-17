class NumberUtils
  attr_accessor :prime_factorizations, :upper_bound

  def initialize(upper_bound = 1_000)
    @prime_factorizations = {}
    @upper_bound = upper_bound
    factorize_range
  end

  def factorize_range
    1.upto(@upper_bound) do |i|
      @prime_factorizations[i] = factorize(i)
    end
  end

  def factorize(num)
    dividend = num
    primes = []
    2.upto(num) do |prime|
      while (dividend % prime).zero?
        primes << prime
        dividend = dividend / prime
      end
    end
    primes
  end

  def get_prime_factorizations(i)
    raise 'Value too high!' unless i <= @i
    @prime_factorizations[i]
  end

  def all
    @prime_factorizations
  end
end


u = NumberUtils.new(100)
puts u.all
