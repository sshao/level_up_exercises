require 'spec_helper'

describe Bomb do
  let(:bomb) { Bomb.new }
  let(:default_activation_code) { "1234" }
  let(:default_deactivation_code) { "0000" }
  
  describe "#new" do  
    it "sets default activation code to 1234" do
      expect(bomb.instance_variable_get(:@activation_code)).to eq default_activation_code
    end

    it "sets default deactivation code to 0000" do
      expect(bomb.instance_variable_get(:@deactivation_code)).to eq default_deactivation_code
    end

    it "sets the bomb state to deactivated" do
      expect(bomb.state).to eq :deactivated
    end
  end

  describe "#activation_code" do
    context "with valid activation code" do
      let(:code) { "5555" }

      it "correctly sets activation code" do
        expect{bomb.activation_code(code)}.to change{bomb.instance_variable_get(:@activation_code)}.to("5555")
      end

      it "returns truthy" do
        expect(bomb.activation_code(code)).to be_truthy
      end
    end
    
    context "with invalid activation code" do
      context "that is >4 characters" do
        let(:code) { "22222" }

        it "does not change the activation code" do
          expect{bomb.activation_code(code)}.to_not change{bomb.instance_variable_get(:@activation_code)}
        end

        it "returns falsey" do
          expect(bomb.activation_code(code)).to be_falsey
        end
      end
      
      context "that is <4 characters" do
        let(:code) { "12" }

        it "does not change the activation code" do
          expect{bomb.activation_code(code)}.to_not change{bomb.instance_variable_get(:@activation_code)}
        end

        it "returns falsey" do
          expect(bomb.activation_code(code)).to be_falsey
        end
      end

      context "that is all non-number characters" do
        let(:code) { "aaaa" }

        it "does not change the activation code" do
          expect{bomb.activation_code(code)}.to_not change{bomb.instance_variable_get(:@activation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code(code)).to be_falsey
        end
      end

      context "that is mixed number/non-number characters" do
        let(:code) { "a2a2" }

        it "does not change the activation code" do
          expect{bomb.activation_code(code)}.to_not change{bomb.instance_variable_get(:@activation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code(code)).to be_falsey
        end
      end
    end
  end

  describe "#deactivation_code=" do
    context "with valid deactivation code" do
      let(:code) { "6666" }

      it "correctly sets deactivation code" do
        expect{bomb.deactivation_code(code)}.to change{bomb.instance_variable_get(:@deactivation_code)}
      end

      it "returns truthy" do
        expect(bomb.deactivation_code(code)).to be_truthy
      end
    end

    context "with invalid deactivation code" do
      context "that is >4 characters" do
        let(:code) { "66666" }

        it "does not change the deactivation code" do
          expect{bomb.deactivation_code(code)}.to_not change{bomb.instance_variable_get(:@deactivation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code(code)).to be_falsey
        end
      end
      
      context "that is <4 characters" do
        let(:code) { "666" }

        it "does not change the deactivation code" do
          expect{bomb.deactivation_code(code)}.to_not change{bomb.instance_variable_get(:@deactivation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code(code)).to be_falsey
        end
      end

      context "that is all non-number characters" do
        let(:code) { "aaaa" }

        it "does not change the deactivation code" do
          expect{bomb.deactivation_code(code)}.to_not change{bomb.instance_variable_get(:@deactivation_code)}
        end
        
        it "returns falsey" do
          expect(bomb.activation_code(code)).to be_falsey
        end
      end

      context "that is mixed number/non-number characters" do
        let(:code) { "6a6a" }

        it "does not change the deactivation code" do
          expect{bomb.deactivation_code(code)}.to_not change{bomb.instance_variable_get(:@deactivation_code)}
        end

        it "returns falsey" do
          expect(bomb.activation_code(code)).to be_falsey
        end
      end
    end
  end

  describe "#activate" do
    context "deactivated bomb" do
      context "with correct activation code" do
        it "activates the bomb" do
          expect{bomb.activate(default_activation_code)}.to change{bomb.state}.to(:activated)
        end

        it "returns truthy" do
          expect(bomb.activate(default_activation_code)).to be_truthy
        end
      end

      context "with incorrect activation code" do
        let(:code) { "1111" }

        it "does not activate the bomb" do
          expect{bomb.activate(code)}.to_not change{bomb.state}
        end

        it "returns falsey" do
          expect(bomb.activate(code)).to be_falsey
        end
      end
    end

    context "activated bomb" do
      before(:each) do
        bomb.instance_variable_set(:@state, :activated)
      end

      context "with correct activation code" do
        it "has no effect on bomb state" do
          expect{bomb.activate(default_activation_code)}.to_not change{bomb.state}
        end
        
        it "returns falsey" do
          expect(bomb.activate(default_activation_code)).to be_falsey
        end
      end

      context "with incorrect activation code" do
        let(:code) { "1111" }

        it "has no effect on bomb state" do
          expect{bomb.activate(code)}.to_not change{bomb.state}
        end
        
        it "returns falsey" do
          expect(bomb.activate(code)).to be_falsey
        end
      end
    end

    context "exploded bomb" do
      before(:each) do
        bomb.instance_variable_set(:@state, :exploded)
      end

      context "with correct activation code" do
        it "has no effect on bomb state" do
          expect{bomb.activate(default_activation_code)}.to_not change{bomb.state}
        end
        
        it "returns falsey" do
          expect(bomb.activate(default_activation_code)).to be_falsey
        end
      end

      context "with incorrect activation code" do
        let(:code) { "1111" }

        it "has no effect on bomb state" do
          expect{bomb.activate(code)}.to_not change{bomb.state}
        end
        
        it "returns falsey" do
          expect(bomb.activate(code)).to be_falsey
        end
      end
    end
  end

  describe "#deactivate" do
    context "activated bomb" do 
      before(:each) do
        bomb.instance_variable_set(:@state, :activated)
      end

      context "with correct deactivation code" do
        it "deactivates the bomb" do
          expect{bomb.deactivate(default_deactivation_code)}.to change{bomb.state}.to(:deactivated)
        end

        it "returns truthy" do
          expect(bomb.deactivate(default_deactivation_code)).to be_truthy
        end
      end
    
      context "with incorrect deactivation code" do
        let(:code) { "1111" }

        context "once" do
          it "does not deactivate the bomb" do
            expect{bomb.deactivate(code)}.to_not change{bomb.state}
          end
        
          it "returns falsey" do
            expect(bomb.activate(code)).to be_falsey
          end
        end

        context "three times" do
          it "explodes the bomb" do
            expect{3.times{bomb.deactivate(code)}}.to change{bomb.state}.to(:exploded)
          end
        end
      end
    end

    context "deactivated bomb" do 
      before(:each) do
        allow(bomb).to receive(:state) { :deactivated }
      end

      context "with correct deactivation code" do
        it "has no effect on bomb state" do
          expect{bomb.deactivate(default_deactivation_code)}.to_not change{bomb.state}
        end

        it "returns falsey" do
          expect(bomb.deactivate(default_deactivation_code)).to be_falsey
        end
      end
    
      context "with incorrect deactivation code" do
        let(:code) { "1111" }

        it "has no effect on bomb state" do
          expect{bomb.deactivate(code)}.to_not change{bomb.state}
        end
        
        it "returns falsey" do
          expect(bomb.deactivate(code)).to be_falsey
        end
      end
    end
    
    context "exploded bomb" do
      before(:each) do
        bomb.instance_variable_set(:@state, :exploded)
      end

      context "with correct activation code" do
        it "has no effect on bomb state" do
          expect{bomb.deactivate(default_deactivation_code)}.to_not change{bomb.state}
        end
        
        it "returns falsey" do
          expect(bomb.deactivate(default_deactivation_code)).to be_falsey
        end
      end

      context "with incorrect activation code" do
        let(:code) { "1111" }

        it "has no effect on bomb state" do
          expect{bomb.deactivate(code)}.to_not change{bomb.state}
        end
        
        it "returns falsey" do
          expect(bomb.deactivate(code)).to be_falsey
        end
      end
    end
  end
end

