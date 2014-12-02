require_relative "dino_config"

class DinodexMatchError < RuntimeError; end
class InvalidWeightError < DinodexMatchError; end

class Dino
  attr_accessor :name, :period, :continent, :diet,
    :weight_in_lbs, :walking, :description

  def initialize(dino_hash)
    dino_hash.each { |attribute, value| send("#{attribute}=", value) }
  end

  def matches?(attribute, target)
    return false if send(attribute).nil?
    method_name = "matches_#{attribute}?"

    if self.respond_to?(method_name, true)
      send(method_name, target)
    else
      matches_arbitrary_target?(attribute, target)
    end
  end

  def to_s
    instance_variables.map do |attribute|
      fact = instance_variable_get(attribute)
      "#{attribute}: #{fact}\n" unless fact.nil?
    end.join
  end

  private

  def matches_arbitrary_target?(attribute, target)
    send(attribute).casecmp(target) == 0
  end

  def matches_period?(target_period)
    # FIXME period.downcase.include?
    period.include?(target_period.downcase)
  end

  def matches_description?(target_description)
    # FIXME description.downcase.include?
    description.include?(target_description.downcase)
  end

  def matches_diet?(target_diet)
    if target_diet.casecmp("carnivore") == 0
      carnivore?
    else
      @diet.casecmp(target_diet) == 0
    end
  end

  def carnivore?
    CARNIVORES.include?(@diet)
  end

  def matches_weight_in_lbs?(weight)
    method_name = "#{weight}?"
    send(method_name)
  rescue NoMethodError
    raise InvalidWeightError, "Cannot find dinosaurs of weight #{weight}. "\
      "Try 'big' or 'small' instead"
  end

  def big?
    weight_in_lbs && (@weight_in_lbs > BIG_DINO_WEIGHT_THRESHOLD)
  end

  def small?
    weight_in_lbs && !big?
  end
end
