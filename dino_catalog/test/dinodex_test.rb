require 'minitest/autorun'
require_relative '../dinodex'

# FIXME remove csv, not worth testing incomplete lines?

class DinodexTest < MiniTest::Unit::TestCase

    EXPECTED_DINODEX_OUTPUT = [
            {:name => "albertosaurus", :period => "late cretaceous",
             :continent => "north america", :diet => "carnivore",
             :weight_in_lbs => 2000, :walking => "biped",
             :description => "like a t-rex but smaller."},
            {:name=>"albertonykus", :period=>"early cretaceous",
             :continent=>"north america", :diet=>"insectivore",
             :weight_in_lbs => nil, :walking=>"biped",
             :description=>"earliest known alvarezsaurid."},
            {:name=>"baryonyx", :period=>"early cretaceous",
             :continent=>"europe", :diet=>"piscivore",
             :weight_in_lbs=>6000, :walking=>"biped",
             :description=>"one of the only known dinosaurs with a fish-only diet."},
            {:name=>"deinonychus", :period=>"early cretaceous",
             :continent=>"north america", :diet=>"carnivore",
             :weight_in_lbs=>150, :walking=>"biped",
             :description=>nil},
            {:name=>"diplocaulus", :period=>"late permian",
             :continent=>"north america", :diet=>"carnivore",
             :weight_in_lbs=>nil, :walking=>"quadruped",
             :description=>"they actually had fins on the side of their body."},
            {:name=>"megalosaurus", :period=>"jurassic",
             :continent=>"europe", :diet=>"carnivore",
             :weight_in_lbs=>2200, :walking=>"biped",
             :description=>"originally thought to be a quadriped. first dinosaur to be named."},
            {:name=>"giganotosaurus", :period=>"late cretaceous",
             :continent=>"south america", :diet=>"carnivore",
             :weight_in_lbs=>30420, :walking=>"biped",
             :description=>"largest hunter and also the coolest ever."},
            {:name=>"quetzalcoatlus", :period=>"late cretaceous",
             :continent=>"north america", :diet=>"carnivore",
             :weight_in_lbs=>440, :walking=>"quadriped",
             :description=>"largest known flying animal of all time."},
            {:name=>"yangchuanosaurus", :period=>"oxfordian",
             :continent=>"asia", :diet=>"carnivore",
             :weight_in_lbs=>7200, :walking=>"biped",
             :description=>nil}
        ]
        
    EXPECTED_AFRICAN_OUTPUT = [
            {:name=>"abrictosaurus", :period=>"jurassic", 
             :diet=>"herbivore", :weight_in_lbs=>100,
             :continent=>"africa", :walking=>"biped"},
            {:name=>"afrovenator", :period=>"jurassic",
             :diet=>"carnivore", :weight_in_lbs=>nil,
             :continent=>"africa", :walking=>"biped"},
            {:name=>"carcharodontosaurus", :period=>"albian",
             :diet=>"carnivore", :weight_in_lbs=>3000,
             :continent=>"africa", :walking=>"biped"},
            {:name=>"giraffatitan", :period=>"jurassic",
             :diet=>"herbivore", :weight_in_lbs=>6600,
             :continent=>"africa", :walking=>"quadriped"},
            {:name=>"paralititan", :period=>"cretaceous",
             :diet=>"herbivore", :weight_in_lbs=>120000,
             :continent=>"africa", :walking=>"quadriped"},
            {:name=>"suchomimus", :period=>"cretaceous",
             :diet=>"carnivore", :weight_in_lbs=>10400,
             :continent=>"africa", :walking=>"biped"},
            {:name=>"melanorosaurus", :period=>"triassic",
             :diet=>"herbivore", :weight_in_lbs=>2400,
             :continent=>"africa", :walking=>"quadriped"}
        ]

    def setup 
        @full_dinodex = Dinodex.new([
            File.expand_path('test/fixtures/african_dinoaur_export.csv'),
            File.expand_path('test/fixtures/dinodex.csv')])
    end

    def test_does_not_parse_invalid_csv
      output, = capture_io { Dinodex.new(File.expand_path('test/fixtures/invalid_format.csv')) }
      assert_match /InvalidFormatError/, output
    end

    def test_skips_nonexistent_file
      output, = capture_io { Dinodex.new('') }
      assert_match /not found, skipping/, output
    end

    def test_invalid_weight
      assert_nil @full_dinodex.find({:key => :weight_in_lbs, :target => "asdf"}) 
    end

    def test_parses_complete_dinodex_format
        dinodex = Dinodex.new(File.expand_path(
          'test/fixtures/single_complete_dinodex_input.csv'))

        expected = [ EXPECTED_DINODEX_OUTPUT[0] ]

        assert_equal expected, dinodex.dinos
    end

    def test_parses_incomplete_dinodex_format
        dinodex = Dinodex.new(File.expand_path( 
            'test/fixtures/single_incomplete_dinodex_input.csv'))

        expected = [ EXPECTED_DINODEX_OUTPUT[4] ] 
        
        assert_equal expected, dinodex.dinos
    end

    def test_parses_multiple_dinodex_format
        dinodex = Dinodex.new(File.expand_path(
            'dinodex.csv'))

        assert_equal EXPECTED_DINODEX_OUTPUT, dinodex.dinos
    end

    def test_parses_complete_african_format
        dinodex = Dinodex.new(File.expand_path(
            'test/fixtures/single_complete_african_input.csv'))

        expected = [ EXPECTED_AFRICAN_OUTPUT[0] ]
        
        assert_equal expected, dinodex.dinos
    end

    def test_parses_incomplete_african_format
        dinodex = Dinodex.new(File.expand_path(
            'test/fixtures/single_incomplete_african_input.csv'))

        expected = [ EXPECTED_AFRICAN_OUTPUT[1] ] 
        
        assert_equal expected, dinodex.dinos
    end

    def test_parses_multiple_african_format

        dinodex = Dinodex.new(File.expand_path(
            'african_dinoaur_export.csv'))

        assert_equal EXPECTED_AFRICAN_OUTPUT, dinodex.dinos
    end

    def test_parse_multiple_files
        expected = EXPECTED_AFRICAN_OUTPUT + EXPECTED_DINODEX_OUTPUT

        assert_equal expected, @full_dinodex.dinos
    end        

    def test_finds_nil_diet
        dinodex = Dinodex.new(File.expand_path('test/fixtures/null_values.csv'))

        actual = dinodex.find({:key => :diet, :target => "Carnivore" }).dinos

        assert_empty actual
    end

    def test_finds_nil_weight
        dinodex = Dinodex.new(File.expand_path('test/fixtures/null_values.csv'))

        actual = dinodex.find({:key => :diet, :target => "big" }).dinos

        assert_empty actual
    end

    def test_finds_nil_fact
        dinodex = Dinodex.new(File.expand_path('test/fixtures/null_values.csv'))

        actual = dinodex.find({:key => :period, :target => "jurassic"}).dinos

        assert_empty actual
    end

    def test_finds_no_omnivores
        assert_empty @full_dinodex.find({:key => :diet,
            :target=>"Omnivore"}).dinos
    end

    def test_finds_all_bipeds
        expected = ["albertosaurus", "albertonykus", "baryonyx",
            "deinonychus", "megalosaurus", "giganotosaurus",
            "yangchuanosaurus", "abrictosaurus", "afrovenator",
            "carcharodontosaurus", "suchomimus"]

        actual = @full_dinodex.find({:key => :walking, :target => "Biped"}).dinos
        actual = actual.map { |hash| hash[:name] }

        assert_equal expected.sort, actual.sort
    end

    def test_finds_all_carnivores
        expected = ["albertosaurus", "deinonychus", "diplocaulus",
            "megalosaurus", "giganotosaurus", "quetzalcoatlus",
            "yangchuanosaurus", "afrovenator", "carcharodontosaurus",
            "suchomimus", "albertonykus", "baryonyx"]

        actual = @full_dinodex.find({:key => :diet, :target => "carnivore"}).dinos
        actual = actual.map { |hash| hash[:name] }

        assert_equal expected.sort, actual.sort
    end
    
    def test_finds_all_piscivores
        expected = "baryonyx"
        
        assert_equal expected, @full_dinodex.find({:key => :diet,
            :target=>"piscivore"}).dinos.first[:name]
    end

    def test_finds_all_periods
        expected = ["albertosaurus", "albertonykus", "baryonyx",
            "deinonychus", "giganotosaurus", "quetzalcoatlus", 
            "paralititan", "suchomimus"]

        actual = @full_dinodex.find({:key => :period, :target=>"cretaceous"}).dinos
        actual = actual.map { |hash| hash[:name] }

        assert_equal expected.sort, actual.sort
    end

    def test_finds_big_dinos
        expected = ["albertosaurus", "baryonyx", "megalosaurus",
            "giganotosaurus", "yangchuanosaurus", "carcharodontosaurus",
            "giraffatitan", "paralititan", "suchomimus", "melanorosaurus"]

        actual = @full_dinodex.find({key: :weight_in_lbs, target: "big"}).dinos
        actual = actual.map { |hash| hash[:name] }

        assert_equal expected.sort, actual.sort
    end

    def test_finds_small_dinos
        expected = ["deinonychus", "quetzalcoatlus", "abrictosaurus"]
        
        actual = @full_dinodex.find({:key => :weight_in_lbs, :target=>"small"}).dinos
        actual = actual.map { |hash| hash[:name] }

        assert_equal expected.sort, actual.sort
    end

    def test_finds_multiple_search_criteria
        expected = "paralititan"

        assert_equal expected, @full_dinodex
            .find({:key => :weight_in_lbs, :target=>"big"})
            .find({:key => :period, :target=>"cretaceous"})
            .find({:key => :diet, :target=>"Herbivore"}).dinos.first[:name]
    end

    def test_prints_complete_dino_info
        expected = 
            "name: albertosaurus\n"\
             "period: late cretaceous\n"\
             "continent: north america\n"\
             "diet: carnivore\n"\
             "weight_in_lbs: 2000\n"\
             "walking: biped\n"\
             "description: like a t-rex but smaller.\n"

        assert_equal expected.downcase, 
          @full_dinodex.to_s("albertosaurus").downcase
    end

    def test_prints_incomplete_dino_info
        expected = 
            "Name: Afrovenator\n"\
            "Period: Jurassic\n"\
            "Diet: Carnivore\n"\
            "Walking: Biped\n"\
            "continent: africa\n"\

        assert_equal expected.downcase, 
          @full_dinodex.to_s("afrovenator").downcase
    end

    def test_prints_dino_collection_info
        expected_afrovenator = 
            "Name: Afrovenator\n"\
            "Period: Jurassic\n"\
            "Diet: Carnivore\n"\
            "Walking: Biped\n"
        expected_abrictosaurus =
            "Name: Abrictosaurus\n"\
            "Period: Jurassic\n"\
            "Diet: Herbivore\n"\
            "Weight_In_Lbs: 100\n"\
            "Walking: Biped\n"
        expected_giraffatitan = 
            "Name: Giraffatitan\n"\
            "Period: Jurassic\n"\
            "Diet: Herbivore\n"\
            "Weight_In_Lbs: 6600\n"\
            "Walking: Quadriped\n"
        expected_megalosaurus = 
            "Name: Megalosaurus\n"\
            "Period: Jurassic\n"\
            "Continent: Europe\n"\
            "Diet: Carnivore\n"\
            "Weight_In_Lbs: 2200\n"\
            "Walking: Biped\n"\
            "Description: Originally thought to be a quadriped. First dinosaur to be named.\n"\

        jurassic_dinos = @full_dinodex.find(
            {:key => :period, :target => "jurassic"})

        output = jurassic_dinos.to_s

        assert_includes(output.downcase, expected_afrovenator.downcase)
        assert_includes(output.downcase, expected_abrictosaurus.downcase)
        assert_includes(output.downcase, expected_giraffatitan.downcase)
        assert_includes(output.downcase, expected_megalosaurus.downcase)

    end

end