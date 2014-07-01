require 'spec_helper'

describe Bomb do
  let(:bomb) { Bomb.new }
  let(:default_activation_code) { "1234" }
  let(:default_deactivation_code) { "0000" }
  
  INVALID_CODES = [
    {code: "22222", description: ">4 characters"},
    {code: "12", description: "<4 characters"},
    {code: "aaaa", description: "all non-number characters"},
    {code: "a2a2", description: "mixed number/non-number characters"}
  ]
  
  describe "#new" do  
    it "sets default activation code to 1234" do
      expect(activation_code_set?(bomb, default_activation_code)).to be true
    end

    it "sets default deactivation code to 0000" do
      expect(deactivation_code_set?(bomb, default_deactivation_code)).to be true
    end

    it "sets the bomb state to deactivated" do
      expect(bomb.state).to be :deactivated
    end
  end

  describe "#set_activation_code" do
    context "with valid code" do
      let(:code) { "5555" }

      it "correctly sets activation code" do
        bomb.set_activation_code(code)
        expect(activation_code_set?(bomb, code)).to be true
      end

      it "returns truthy" do
        expect(bomb.set_activation_code(code)).to be_truthy
      end
    end
    
    context "with invalid activation code" do
      INVALID_CODES.each do |code|
        context "that is #{code[:description]}" do
          it "does not change the activation code" do
            bomb.set_activation_code(code[:code])
            expect(activation_code_set?(bomb, code[:code])).to be false
          end

          it "returns falsey" do
            expect(bomb.set_activation_code(code[:code])).to be_falsey
          end
        end
      end
    end
  end

  describe "#set_deactivation_code" do
    context "with valid deactivation code" do
      let(:code) { "6666" }

      it "correctly sets deactivation code" do
        bomb.set_deactivation_code(code)
        expect(deactivation_code_set?(bomb, code)).to be true
      end

      it "returns truthy" do
        expect(bomb.set_deactivation_code(code)).to be_truthy
      end
    end
    
    context "with invalid deactivation code" do
      INVALID_CODES.each do |code|
        context "that is #{code[:description]}" do
          it "does not change the deactivation code" do
            bomb.set_deactivation_code(code[:code])
            expect(deactivation_code_set?(bomb, code[:code])).to be false
          end

          it "returns falsey" do
            expect(bomb.set_deactivation_code(code[:code])).to be_falsey
          end
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
        bomb.activate(default_activation_code)
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
        bomb.activate(default_activation_code)
        3.times{bomb.deactivate("aaaa")}
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
        bomb.activate(default_activation_code)
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
        bomb.activate(default_activation_code)
        3.times{bomb.deactivate("aaaa")}
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

