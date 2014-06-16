require 'minitest/autorun'
require_relative '../dinodex'

class DinodexTest < MiniTest::Unit::TestCase

    def test_parses_complete_dinodex_format
        expected_output = [{
            :name => "Albertosaurus",
            :period => "Late Cretaceous",
            :continent => "North America",
            :diet => "Carnivore",
            :weight_in_lbs => 2000,
            :walking => "Biped",
            :description => "Like a T-Rex but smaller."
        }]

        dinodex = Dinodex.new(File.expand_path(
            'test/fixtures/single_complete_dinodex_input.csv'))

        assert_equal expected_output, dinodex.entries
    end

    def test_parses_incomplete_dinodex_format
        expected_output = [{
            :name=>"Diplocaulus",
            :period=>"Late Permian",
            :continent=>"North America",
            :diet=>"Carnivore",
            :weight_in_lbs=>nil,
            :walking=>"Quadruped",
            :description=>"They actually had fins on the side of their body."
        }]

        dinodex = Dinodex.new(File.expand_path(
            'test/fixtures/single_incomplete_dinodex_input.csv'))

        assert_equal expected_output, dinodex.entries
    end

    def test_parses_african_format
        expected_output = [{
            :name=>"Abrictosaurus",
            :period=>"Jurassic",
            :diet=>"Non-Carnivore",
            :weight_in_lbs=>100,
            :walking=>"Biped",
        }]

        dinodex = Dinodex.new(File.expand_path(
            'test/fixtures/single_complete_african_input.csv'))

        assert_equal expected_output, dinodex.entries
    end

end
