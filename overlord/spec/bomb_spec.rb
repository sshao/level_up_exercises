require 'spec_helper'

describe Bomb do
  describe "#new" do
    it "sets default activation code to 1234"
    it "sets default deactivation code to 0000"
    it "sets the bomb state to deactivated"
  end

  describe "#activation_code=" do
    context "with valid activation code" do
      it "correctly sets activation code" 
    end
    
    context "with invalid activation code" do
      context "with >4 characters" do
        it "does not change the activation code"
      end
      
      context "with <4 characters" do
        it "does not change the activation code"
      end

      context "with all non-number characters" do
        it "does not change the activation code"
      end

      context "with mixed number/non-number characters" do
        it "does not change the activation code"
      end
    end
  end

  describe "#deactivation_code=" do
    context "with valid deactivation code" do
      it "correctly sets deactivation code"
    end

    context "with invalid deactivation code" do
      context "with >4 characters" do
        it "does not change the deactivation code"
      end
      
      context "with <4 characters" do
        it "does not change the deactivation code"
      end

      context "with all non-number characters" do
        it "does not change the deactivation code"
      end

      context "with mixed number/non-number characters" do
        it "does not change the deactivation code"
      end
    end
  end

  describe "#activate" do
    context "with deactivated bomb" do
      context "with correct activation code" do
        it "activates the bomb"
      end

      context "with incorrect activation code" do
        it "does not activate the bomb"
      end
    end

    context "with activated bomb" do
      context "with correct activation code" do
        it "has no effect on bomb state"
      end

      context "with incorrect activation code" do
        it "has no effect on bomb state"
      end
    end
  end

  describe "#deactivate" do
    context "with activated bomb" do 
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

    context "with deactivated bomb" do 
      context "with correct deactivation code" do
        it "has no effect on bomb state"
      end
    
      context "with incorrect deactivation code" do
        it "has no effect on bomb state"
      end
    end
  end
end

