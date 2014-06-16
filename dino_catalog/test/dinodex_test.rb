require 'minitest/autorun'
require_relative '../dinodex'

class DinodexTest < MiniTest::Unit::TestCase

    EXPECTED_DINODEX_OUTPUT = [
            {:name => "Albertosaurus", :period => "Late Cretaceous",
             :continent => "North America", :diet => "Carnivore",
             :weight_in_lbs => 2000, :walking => "Biped",
             :description => "Like a T-Rex but smaller."},
            {:name=>"Albertonykus", :period=>"Early Cretaceous",
             :continent=>"North America", :diet=>"Insectivore",
             :weight_in_lbs => nil, :walking=>"Biped",
             :description=>"Earliest known Alvarezsaurid."},
            {:name=>"Baryonyx", :period=>"Early Cretaceous",
             :continent=>"Europe", :diet=>"Piscivore",
             :weight_in_lbs=>6000, :walking=>"Biped",
             :description=>"One of the only known dinosaurs with a fish-only diet."},
            {:name=>"Deinonychus", :period=>"Early Cretaceous",
             :continent=>"North America", :diet=>"Carnivore",
             :weight_in_lbs=>150, :walking=>"Biped",
             :description=>nil},
            {:name=>"Diplocaulus", :period=>"Late Permian",
             :continent=>"North America", :diet=>"Carnivore",
             :weight_in_lbs=>nil, :walking=>"Quadruped",
             :description=>"They actually had fins on the side of their body."},
            {:name=>"Megalosaurus", :period=>"Jurassic",
             :continent=>"Europe", :diet=>"Carnivore",
             :weight_in_lbs=>2200, :walking=>"Biped",
             :description=>"Originally thought to be a quadriped. First dinosaur to be named."},
            {:name=>"Giganotosaurus", :period=>"Late Cretaceous",
             :continent=>"South America", :diet=>"Carnivore",
             :weight_in_lbs=>30420, :walking=>"Biped",
             :description=>"Largest hunter and also the coolest ever."},
            {:name=>"Quetzalcoatlus", :period=>"Late Cretaceous",
             :continent=>"North America", :diet=>"Carnivore",
             :weight_in_lbs=>440, :walking=>"Quadriped",
             :description=>"Largest known flying animal of all time."},
            {:name=>"Yangchuanosaurus", :period=>"Oxfordian",
             :continent=>"Asia", :diet=>"Carnivore",
             :weight_in_lbs=>7200, :walking=>"Biped",
             :description=>nil}
        ]
        
    EXPECTED_AFRICAN_OUTPUT = [
            {:name=>"Abrictosaurus", :period=>"Jurassic", 
             :diet=>"Non-Carnivore", :weight_in_lbs=>100,
             :walking=>"Biped"},
            {:name=>"Afrovenator", :period=>"Jurassic",
             :diet=>"Carnivore", :weight_in_lbs=>nil,
             :walking=>"Biped"},
            {:name=>"Carcharodontosaurus", :period=>"Albian",
             :diet=>"Carnivore", :weight_in_lbs=>3000,
             :walking=>"Biped"},
            {:name=>"Giraffatitan", :period=>"Jurassic",
             :diet=>"Non-Carnivore", :weight_in_lbs=>6600,
             :walking=>"Quadriped"},
            {:name=>"Paralititan", :period=>"Cretaceous",
             :diet=>"Non-Carnivore", :weight_in_lbs=>120000,
             :walking=>"Quadriped"},
            {:name=>"Suchomimus", :period=>"Cretaceous",
             :diet=>"Carnivore", :weight_in_lbs=>10400,
             :walking=>"Biped"},
            {:name=>"Melanorosaurus", :period=>"Triassic",
             :diet=>"Non-Carnivore", :weight_in_lbs=>2400,
             :walking=>"Quadriped"}
        ]

    def test_parses_complete_dinodex_format
        dinodex = Dinodex.new(File.expand_path(
            'test/fixtures/single_complete_dinodex_input.csv'))

        expected = [ EXPECTED_DINODEX_OUTPUT[0] ]

        assert_equal expected, dinodex.entries
    end

    def test_parses_incomplete_dinodex_format
        dinodex = Dinodex.new(File.expand_path( 
            'test/fixtures/single_incomplete_dinodex_input.csv'))

        expected = [ EXPECTED_DINODEX_OUTPUT[4] ] 
        
        assert_equal expected, dinodex.entries
    end

    def test_parses_multiple_dinodex_format
        dinodex = Dinodex.new(File.expand_path(
            'dinodex.csv'))

        assert_equal EXPECTED_DINODEX_OUTPUT, dinodex.entries
    end

    def test_parses_complete_african_format
        dinodex = Dinodex.new(File.expand_path(
            'test/fixtures/single_complete_african_input.csv'))

        expected = [ EXPECTED_AFRICAN_OUTPUT[0] ]
        
        assert_equal expected, dinodex.entries
    end

    def test_parses_incomplete_african_format
        dinodex = Dinodex.new(File.expand_path(
            'test/fixtures/single_incomplete_african_input.csv'))

        expected = [ EXPECTED_AFRICAN_OUTPUT[1] ] 
        
        assert_equal expected, dinodex.entries
    end

    def test_parses_multiple_african_format

        dinodex = Dinodex.new(File.expand_path(
            'african_dinoaur_export.csv'))

        assert_equal EXPECTED_AFRICAN_OUTPUT, dinodex.entries
    end

    def test_parse_multiple_files
        expected = EXPECTED_AFRICAN_OUTPUT + EXPECTED_DINODEX_OUTPUT

        dinodex = Dinodex.new(
            File.expand_path('african_dinoaur_export.csv'),
            File.expand_path('dinodex.csv'))

        assert_equal expected, dinodex.entries
    end        

end
