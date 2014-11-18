require_relative "../dinodex"

describe Dinodex do
  let(:african_dinodex_file) { "./african_dinosaur_export.csv" }
  let(:dinodex_file) { "./dinodex.csv" }
  let(:invalid_file) { "./spec/fixtures/invalid_format.csv" }

  let(:african_dinodex) { Dinodex.new(african_dinodex_file) }
  let(:single_dinodex) { Dinodex.new(dinodex_file) }
  let(:invalid_dinodex) { Dinodex.new(invalid_file) }
  let(:dinodex) { Dinodex.new([african_dinodex_file, dinodex_file]) }

  context "#initialize" do
    context "with valid CSV files" do
      context "with the Dinodex CSV file" do
        it "should load all dinosaurs" do
          expect(single_dinodex.size).to be 9
        end
      end

      context "with the African CSV file" do
        it "should load all dinosaurs" do
          expect(african_dinodex.size).to be 7
        end
      end

      it "should load all dinosaurs from multiple files" do
        expect(dinodex.size).to be 16
      end
    end

    context "with invalid CSV files" do
      it "should throw an InvalidFormatError" do
        expect { invalid_dinodex }.to raise_error(InvalidFormatError)
      end
    end
  end

  context "#find" do
    it "should find all dinosaurs without descriptions" do
      pending
      expect(dinodex.find(description: nil).size).to be 9
    end

    it "should find all dinosaurs named Suchomimus" do
      expect(dinodex.find(name: "suchomimus").size).to be 1
    end

    it "should find all dinosaurs from the Cretaceous period" do
      cretaceous_dinos = dinodex.find(period: "cretaceous")
      expect(cretaceous_dinos.size).to be 8
    end

    it "should not find any dinos from invalid periods" do
      pending
      late_dinos = dinodex.find(period: "late")
      expect(late_dinos.size).to be 0
    end

    it "should find all dinosaurs from Africa" do
      african_dinos = dinodex.find(continent: "africa")
      expect(african_dinos.size).to be 7
    end

    it "should find all dinosaurs from North America" do
      north_american_dinos = dinodex.find(continent: "north america")
      expect(north_american_dinos.size).to be 5
    end

    it "should not find any dinosaurs from 'America'" do
      pending
      american_dinos = dinodex.find(continent: "america")
      expect(american_dinos.size).to be 0
    end

    it "should find all dinosaurs that were piscivores" do
      piscivores = dinodex.find(diet: "piscivore")
      expect(piscivores.size).to be 1
    end

    it "should find all dinosaurs that were carnivores" do
      carnivores = dinodex.find(diet: "carnivore")
      expect(carnivores.size).to be 12
    end

    it "should raise an InvalidWeightError if searching for an invalid weight target (anything not 'big' or 'small')" do
      expect { dinodex.find(weight_in_lbs: 200) }.to raise_error(InvalidWeightError)
    end

    it "should find all big dinosaurs" do
      big_dinos = dinodex.find(weight_in_lbs: "big")
      expect(big_dinos.size).to be 9
    end

    it "should find all small dinosaurs" do
      small_dinos = dinodex.find(weight_in_lbs: "small")
      expect(small_dinos.size).to be 4
    end

    it "should find all dinosaurs that were bipeds" do
      bipeds = dinodex.find(walking: "biped")
      expect(bipeds.size).to be 11
    end

    it "should find all dinosaurs with description 'flying animal'" do
      flying = dinodex.find(description: "flying animal")
      expect(flying.size).to be 1
      expect(flying.to_s.downcase).to include("quetzalcoatlus")
    end

    it "should find all big Jurassic dinos" do
      jurassic_dinos = dinodex.find(period: "jurassic")
      big_jurassic_dinos = jurassic_dinos.find(weight_in_lbs: "big")
      expect(big_jurassic_dinos.size).to be 2

      big_dinos = dinodex.find(weight_in_lbs: "big")
      jurassic_big_dinos = big_dinos.find(period: "jurassic")
      expect(jurassic_big_dinos.size).to be 2
    end

    it "should be case-insensitive" do
      pending
      expect(dinodex.find(name: "Suchomimus").size).to be 1
    end
  end

  context "#to_s" do
    let(:dinodex) { Dinodex.new(["./dinodex.csv", "./african_dinosaur_export.csv"]) }

    it "should print all facts about Dinodex dino Megalosaurus" do
      megalosaurus_str = dinodex.find(name: "megalosaurus").to_s
      expect(megalosaurus_str).to include("name: megalosaurus")
      expect(megalosaurus_str).to include("period: jurassic")
      expect(megalosaurus_str).to include("continent: europe")
      expect(megalosaurus_str).to include("diet: carnivore")
      expect(megalosaurus_str).to include("weight_in_lbs: 2200")
      expect(megalosaurus_str).to include("walking: biped")
      expect(megalosaurus_str).to include("description: originally thought to be a quadriped. first dinosaur to be named.")
    end

    it "should not print a description or weight for Afrovenator" do
      afrovenator_str = dinodex.find(name: "afrovenator").to_s
      expect(afrovenator_str).to_not include("description")
      expect(afrovenator_str).to_not include("weight")
    end

    it "should print all dinosaurs from the Jurassic period" do
      jurassic_dinos = dinodex.find(period: "jurassic").to_s
      expected_dinos = ["megalosaurus", "abrictosaurus", "afrovenator", "giraffatitan"]

      expected_dinos.each { |expected_dino| expect(jurassic_dinos).to include(expected_dino) }
    end
  end
end
