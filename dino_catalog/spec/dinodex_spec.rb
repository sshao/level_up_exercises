require "rspec/collection_matchers"
require_relative "../dinodex"

describe Dinodex do
  FIXTURES_PATH = "./spec/fixtures/"
  let(:african_dinodex_file) { File.join(FIXTURES_PATH, "african_dinosaur_export.csv") }
  let(:dinodex_file) { File.join(FIXTURES_PATH, "dinodex.csv") }
  let(:invalid_file) { File.join(FIXTURES_PATH, "invalid_format.csv") }
  let(:missing_file) { File.join(FIXTURES_PATH, "missing_file.csv") }

  let(:african_dinodex) { Dinodex.new(filepaths: african_dinodex_file) }
  let(:single_dinodex) { Dinodex.new(filepaths: dinodex_file) }
  let(:invalid_dinodex) { Dinodex.new(filepaths: invalid_file) }
  let(:missing_dinodex) { Dinodex.new(filepaths: [african_dinodex_file, missing_file]) }
  let(:dinodex) { Dinodex.new(filepaths: [african_dinodex_file, dinodex_file]) }

  context "#initialize" do
    context "with valid CSV files" do
      context "with the Dinodex CSV file" do
        it "loads all dinosaurs" do
          expect(single_dinodex).to have(9).dinos
        end
      end

      context "with the African CSV file" do
        it "loads all dinosaurs" do
          expect(african_dinodex).to have(7).dinos
        end
      end

      it "loads all dinosaurs from multiple files" do
        expect(dinodex).to have(16).dinos
      end
    end

    context "with invalid CSV files" do
      it "throws an InvalidFormatError" do
        expect { invalid_dinodex }.to raise_error(InvalidFormatError)
      end
    end

    context "with non-existent files" do
      it "skips the file" do
        expect(missing_dinodex).to have(7).dinos
      end
    end
  end

  context "#find" do
    it "finds all dinosaurs without descriptions" do
      pending("still deciding whether or not this is a "\
              "requirement that needs to be implemented")
      expect(dinodex.find(description: nil)).to have(9).dinos
    end

    it "finds all dinosaurs named 'suchomimus'" do
      expect(dinodex.find(name: "suchomimus")).to have(1).dinos
    end

    it "finds all dinosaurs from the 'cretaceous' period" do
      cretaceous_dinos = dinodex.find(period: "cretaceous")
      expect(cretaceous_dinos).to have(8).dinos
    end

    it "does not find any dinos from the invalid period 'late'" do
      pending("still deciding whether or not this is a "\
              "requirement that needs to be implemented")
      late_dinos = dinodex.find(period: "late")
      expect(late_dinos).to have(0).dinos
    end

    it "finds all dinosaurs from continent 'africa'" do
      african_dinos = dinodex.find(continent: "africa")
      expect(african_dinos).to have(7).dinos
    end

    it "finds all dinosaurs from continent 'north america'" do
      north_american_dinos = dinodex.find(continent: "north america")
      expect(north_american_dinos).to have(5).dinos
    end

    it "does not find any dinosaurs from continent 'america'" do
      american_dinos = dinodex.find(continent: "america")
      expect(american_dinos).to have(0).dinos
    end

    it "finds all dinosaurs with diet 'piscivore'" do
      piscivores = dinodex.find(diet: "piscivore")
      expect(piscivores).to have(1).dinos
    end

    it "finds all dinosaurs with diet 'herbivore'" do
      herbivores = dinodex.find(diet: "herbivore")
      expect(herbivores).to have(4).dinos
    end

    it "finds all dinosaurs with diet 'carnivore'" do
      carnivores = dinodex.find(diet: "carnivore")
      expect(carnivores).to have(12).dinos
    end

    it "raises an InvalidWeightError if given an invalid weight target" do
      expect { dinodex.find(weight_in_lbs: 200) }.to raise_error(InvalidWeightError)
    end

    it "finds all 'big' dinosaurs" do
      big_dinos = dinodex.find(weight_in_lbs: "big")
      expect(big_dinos).to have(9).dinos
    end

    it "finds all 'small' dinosaurs" do
      small_dinos = dinodex.find(weight_in_lbs: "small")
      expect(small_dinos).to have(4).dinos
    end

    it "finds all dinosaurs with walking type 'biped'" do
      bipeds = dinodex.find(walking: "biped")
      expect(bipeds).to have(11).dinos
    end

    it "finds all dinosaurs with description 'flying animal'" do
      flying = dinodex.find(description: "flying animal")
      expect(flying).to have(1).dinos
      expect(flying.to_s.downcase).to include("quetzalcoatlus")
    end

    it "finds all 'big' dinos and all 'Jurassic' dinos" do
      big_jurassic_dinos = dinodex.find(period: "jurassic", weight_in_lbs: "big")
      expect(big_jurassic_dinos).to have(13).dinos
    end

    it "finds all 'big', 'Jurassic' dinos with chained #find" do
      jurassic_dinos = dinodex.find(period: "jurassic")
      big_jurassic_dinos = jurassic_dinos.find(weight_in_lbs: "big")
      expect(big_jurassic_dinos).to have(2).dinos

      big_dinos = dinodex.find(weight_in_lbs: "big")
      jurassic_big_dinos = big_dinos.find(period: "jurassic")
      expect(jurassic_big_dinos).to have(2).dinos
    end

    it "is case-insensitive" do
      expect(dinodex.find(name: "Suchomimus")).to have(1).dinos
      expect(dinodex.find(period: "Oxfordian")).to have(1).dinos
      expect(dinodex.find(continent: "Asia")).to have(1).dinos
      expect(dinodex.find(diet: "Piscivore")).to have(1).dinos
      expect(dinodex.find(diet: "Carnivore")).to have(12).dinos
      expect(dinodex.find(walking: "Biped")).to have(11).dinos
      expect(dinodex.find(description: "LIKE A T-REX BUT SMaLLER")).to have(1).dinos
    end
  end

  context "#to_s" do
    it "prints all facts about Dinodex dino 'megalosaurus'" do
      megalosaurus_str = dinodex.find(name: "megalosaurus").to_s
      expect(megalosaurus_str).to include("name: megalosaurus")
      expect(megalosaurus_str).to include("period: jurassic")
      expect(megalosaurus_str).to include("continent: europe")
      expect(megalosaurus_str).to include("diet: carnivore")
      expect(megalosaurus_str).to include("weight_in_lbs: 2200")
      expect(megalosaurus_str).to include("walking: biped")
      expect(megalosaurus_str).to include("description: originally thought to "\
                                          "be a quadruped. first dinosaur to be "\
                                          "named.")
    end

    it "does not print description or weight for Dinodex dino 'afrovenator'" do
      afrovenator_str = dinodex.find(name: "afrovenator").to_s
      expect(afrovenator_str).to_not include("description")
      expect(afrovenator_str).to_not include("weight")
    end

    it "prints all dinosaurs from the 'jurassic' period" do
      jurassic_dinos = dinodex.find(period: "jurassic").to_s
      expected_dinos = %w(megalosaurus abrictosaurus afrovenator giraffatitan)

      expected_dinos.each { |dino| expect(jurassic_dinos).to include(dino) }
    end
  end
end
