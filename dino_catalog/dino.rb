require_relative 'dinodex_config'

class DinodexMatchError < RuntimeError; end
class InvalidWeightError < DinodexMatchError; end

class Dino
  attr_reader :name, :period, :continent, :diet, :weight_in_lbs, :walking, :description

  def initialize(record)
    record.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def matches?(search)
    key = search.keys.first
    target = search[key]

    method_name = "matches_#{key.to_s}?"

    if self.respond_to? method_name, true
      send(method_name, target)
    else
      matches_arbitrary_target?(key, target)
    end
  end

  def matches_arbitrary_target?(key, target)
    return false if send(key).nil?
    send(key).include? target
  end

  def matches_diet?(target_diet)
    if target_diet == "carnivore"
      CARNIVORES.include?(@diet)
    else
      @diet == target_diet
    end
  end

  def matches_weight_in_lbs?(weight)
    method_name = "is_#{weight}?"
    send(method_name)
  rescue NoMethodError
    raise InvalidWeightError, "Cannot find dinosaurs of weight #{weight}. Try 'big' or 'small' instead"
  end

  def is_big?
    return false if @weight_in_lbs.nil?
    @weight_in_lbs > BIG_DINO_WEIGHT_THRESHOLD
  end

  def is_small?
    return false if @weight_in_lbs.nil?
    !is_big?
  end

  def to_s
    instance_variables.map do |instance_variable|
      fact = instance_variable_get(instance_variable)
      unless fact.nil?
        "#{instance_variable}: #{fact}\n"
      end
    end.join
  end
end
