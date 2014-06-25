require 'spec_helper'

describe Bomb do
  describe "#new" do
    it "sets default activation code to 1234"
    it "sets default deactivation code to 0000"
  end

  describe "#activation_code=" do
    it "correctly sets activation code" 
  end

  describe "#deactivation_code=" do
    it "correctly sets deactivation code"
  end

  describe "#activate" do
    context "with correct activation code" do
      it "activates the bomb"
    end

    context "with incorrect activation code" do
      it "does not activate the bomb"
    end
  end

  describe "#deactivate" do
    context "with correct deactivation code" do
      it "deactivates the bomb"
    end
  
    context "with incorrect deactivation code" do
      context "once" do
        it "does not deactivate the bomb"
      end

      context "three times" do
        it "explodes the bomb"
      end
    end
  end
end

