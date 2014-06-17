require 'csv'

class Dinodex

    attr_reader :entries

    def initialize(*filepaths)
        @entries = []

        filepaths.each do |path|
            body = File.read(path).downcase

            body = parse_african(body) if body =~ /Genus,Period,Carnivore,Weight,Walking/i

            csv = CSV.new(body, :headers => true,
                :header_converters => :symbol,
                :converters => :all)

            @entries.concat csv.to_a.map{|row| row.to_hash}
        end
    end

    def find(*searches)
        results = @entries.select { |dino| dino_matches_all?(dino, *searches) }
        results.map{|dino| dino[:name]}
    end

    def print_dinos(names)
        names = Array(names)
        names.each do |name|
            dino = @entries.find { |dino| dino[:name].casecmp(name).zero? }
            dino.each do |key, value| 
                puts "#{key}: #{value}\n" unless value.nil?
            end
        end
    end

    private
        def parse_african(body)
            body.gsub!(/Genus/i, 'name')
            body.gsub!(/Carnivore/i, 'diet')
            body.gsub!(/Weight/i, 'weight_in_lbs')

            body.gsub!(/,No,/i, ',herbivore,')
            body.gsub!(/,Yes,/i, ',carnivore,')

            body
        end

        def dino_matches_all?(dino, *searches)
            matches_all = true
            searches.each do |search|
                if dino[search[:key]].nil?
                    matches_all = false
                    break
                end

                if search[:key].eql?(:weight_in_lbs)
                    matches_all = false unless matches_weight?(dino, search[:targets])
                elsif search[:key].eql?(:diet)
                    matches_all = false unless matches_diet?(dino, search[:targets])
                else
                    matches_all = false unless dino[search[:key]].include? (search[:targets])
                end

                break unless matches_all
            end

            matches_all
        end

        def matches_diet?(dino, diet)
            return false if dino[:diet].nil?
                
            if diet.casecmp("carnivore").zero?
                true if ["carnivore", "insectivore", "piscivore"].any? { |diet| diet.casecmp(dino[:diet]).zero? }
            else
                true if dino[:diet].casecmp(diet).zero?
            end
        end

        def matches_weight?(dino, weight)
            return false if dino[:weight_in_lbs].nil?

            if weight.casecmp("big").zero?
                dino[:weight_in_lbs] >= 2000
            else
                dino[:weight_in_lbs] < 2000
            end
        end

end
