require 'spec_helper'

describe Bomb do
  describe "#new" do
    let(:bomb) { Bomb.new }
    
    it "sets default activation code to 1234" do
      expect(bomb.instance_variable_get(:@activation_code)).to eq "1234"
    end

    it "sets default deactivation code to 0000" do
      expect(bomb.instance_variable_get(:@deactivation_code)).to eq "0000"
    end

    it "sets the bomb state to deactivated" do
      expect(bomb.state).to eq :deactivated
    end
  end

  describe "#activation_code" do
    let(:bomb) { Bomb.new }

    context "with valid activation code" do
      it "correctly sets activation code" do
        expect{bomb.activation_code("5555")}.to change{bomb.instance_variable_get(:@activation_code)}.to("5555")
      end

      it "returns truthy" do
        expect(bomb.activation_code("5555")).to be_truthy
      end
    end
    
    context "with invalid activation code" do
      context "with >4 characters" do
        it "does not change the activation code" do
          expect{bomb.activation_code("22222")}.to_not change{bomb.instance_variable_get(:@activation_code)}
        end

        it "returns falsey" do
          expect(bomb.activation_code("22222")).to be_falsey
        end
      end
      
      context "with <4 characters" do
        it "does not change the activation code" do
          expect{bomb.activation_code("12")}.to_not change{bomb.instance_variable_get(:@activation_code)}
        end

        it "returns falsey" do
          expect(bomb.activation_code("12")).to be_falsey
        end
      end

      context "with all non-number characters" do
        it "does not change the activation code" do
          expect{bomb.activation_code("aaaa")}.to_not change{bomb.instance_variable_get(:@activation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code("aaaa")).to be_falsey
        end
      end

      context "with mixed number/non-number characters" do
        it "does not change the activation code" do
          expect{bomb.activation_code("a2a2")}.to_not change{bomb.instance_variable_get(:@activation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code("a2a2")).to be_falsey
        end
      end
    end
  end

  describe "#deactivation_code=" do
    let(:bomb) { Bomb.new }

    context "with valid deactivation code" do
      it "correctly sets deactivation code" do
        expect{bomb.deactivation_code("6666")}.to change{bomb.instance_variable_get(:@deactivation_code)}
      end

      it "returns truthy" do
        expect(bomb.deactivation_code("6666")).to be_truthy
      end
    end

    context "with invalid deactivation code" do
      context "with >4 characters" do
        it "does not change the deactivation code" do
          expect{bomb.deactivation_code("66666")}.to_not change{bomb.instance_variable_get(:@deactivation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code("66666")).to be_falsey
        end
      end
      
      context "with <4 characters" do
        it "does not change the deactivation code" do
          expect{bomb.deactivation_code("666")}.to_not change{bomb.instance_variable_get(:@deactivation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code("666")).to be_falsey
        end
      end

      context "with all non-number characters" do
        it "does not change the deactivation code" do
          expect{bomb.deactivation_code("aaaa")}.to_not change{bomb.instance_variable_get(:@deactivation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code("aaaa")).to be_falsey
        end
      end

      context "with mixed number/non-number characters" do
        it "does not change the deactivation code" do
          expect{bomb.deactivation_code("6a6a")}.to_not change{bomb.instance_variable_get(:@deactivation_code)}
        end

        it "returns falsey" do
          expect(bomb.activation_code("6a6a")).to be_falsey
        end
      end
    end
  end

  describe "#activate" do
    let(:bomb) { Bomb.new }

    context "with deactivated bomb" do
      context "with correct activation code" do
        it "activates the bomb" do
          expect{bomb.activate("1234")}.to change{bomb.state}.to(:activated)
        end
      end

      context "with incorrect activation code" do
        it "does not activate the bomb" do
          expect{bomb.activate("1111")}.to_not change{bomb.state}
        end
      end
    end

    context "with activated bomb" do
      before(:each) do
        bomb.instance_variable_set(:@state, :activated)
      end

      context "with correct activation code" do
        it "has no effect on bomb state" do
          expect{bomb.activate("1234")}.to_not change{bomb.state}
        end
      end

      context "with incorrect activation code" do
        it "has no effect on bomb state" do
          expect{bomb.activate("1111")}.to_not change{bomb.state}
        end
      end
    end

    context "with exploded bomb" do
      before(:each) do
        bomb.instance_variable_set(:@state, :exploded)
      end

      context "with correct activation code" do
        it "has no effect on bomb state" do
          expect{bomb.activate("1234")}.to_not change{bomb.state}
        end
      end

      context "with incorrect activation code" do
        it "has no effect on bomb state" do
          expect{bomb.activate("1111")}.to_not change{bomb.state}
        end
      end
    end
  end

  describe "#deactivate" do
    let(:bomb) { Bomb.new }

    context "with activated bomb" do 
      before(:each) do
        bomb.instance_variable_set(:@state, :activated)
      end

      context "with correct deactivation code" do
        it "deactivates the bomb" do
          expect{bomb.deactivate("0000")}.to change{bomb.state}.to(:deactivated)
        end
      end
    
      context "with incorrect deactivation code" do
        context "once" do
          it "does not deactivate the bomb" do
            expect{bomb.deactivate("1111")}.to_not change{bomb.state}
          end
        end

        context "three times" do
          it "explodes the bomb" do
            expect{3.times{bomb.deactivate("1111")}}.to change{bomb.state}.to(:exploded)
          end
        end
      end
    end

    context "with deactivated bomb" do 
      before(:each) do
        allow(bomb).to receive(:state) { :deactivated }
      end

      context "with correct deactivation code" do
        it "has no effect on bomb state" do
          expect{bomb.deactivate("0000")}.to_not change{bomb.state}
        end
      end
    
      context "with incorrect deactivation code" do
        it "has no effect on bomb state" do
          expect{bomb.deactivate("1111")}.to_not change{bomb.state}
        end
      end
    end
    
    context "with exploded bomb" do
      before(:each) do
        bomb.instance_variable_set(:@state, :exploded)
      end

      context "with correct activation code" do
        it "has no effect on bomb state" do
          expect{bomb.deactivate("0000")}.to_not change{bomb.state}
        end
      end

      context "with incorrect activation code" do
        it "has no effect on bomb state" do
          expect{bomb.deactivate("1111")}.to_not change{bomb.state}
        end
      end
    end
  end
end

