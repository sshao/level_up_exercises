class NameCollisionError < RuntimeError; end;

class Robot
  attr_accessor :name

  @@registry

  def initialize(args = {})
    @@registry ||= []
    @name_generator = args[:name_generator]

    if @name_generator
      @name = @name_generator.call
    else
      generate_char = -> { ('A'..'Z').to_a.sample }
      generate_num = -> { rand(10) }

      @name = default_name_generator(generate_char, generate_num)
    end

    raise NameCollisionError, "Generated robot name #{name} was invalid" unless valid_name?(name)
    raise NameCollisionError, "Generated robot name #{name} already exists" if name_exists?(name)
    @@registry << @name
  end

  private
  def valid_name?(name)
    name =~ /\w{2|\d{3}/
  end

  def name_exists?(name)
    @@registry.include?(name)
  end

  def default_name_generator(generate_char, generate_num)
    (2.times.collect { generate_char.call } + 
      3.times.collect { generate_num.call }).join
  end

end

robot = Robot.new
puts "My pet robot's name is #{robot.name}, but we usually call him sparky."

# Errors!
generator = -> { 'AA111' }
Robot.new(name_generator: generator)
Robot.new(name_generator: generator)
