require 'csv'

class Dinodex

    attr_reader :entries

    def initialize(*filepaths)
        @entries = []

        filepaths.each do |path|
            # TODO error checking
            body = File.read(path)

            if body =~ /Genus,Period,Carnivore,Weight,Walking/
                body = parse_african(body)
            end

            csv = CSV.new(body, :headers => true,
                :header_converters => :symbol,
                :converters => :all)

            @entries.concat csv.to_a.map{|row| row.to_hash}
        end
    end

    def find(*searches)
        results = []

        searches.each do |search|
            values = search[:values].map(&:downcase)

            if search[:key].eql?(:weight_in_lbs)
                results.concat find_by_weight(values[0])
            else
                results.concat( @entries.select do |dino|
                    values.any? { |value| 
                        dino[search[:key]].downcase.include? value } 
                end )
            end
        end
        
        results.map{|dino| dino[:name]}.uniq
    end

    def print_dinos(names)
        names = Array(names)
        str = ""
        names.each do |name|
            dino = @entries.select { |dino| dino[:name].casecmp(name).zero? }
            dino[0].each do |key, value|
                str << "#{key}: #{value}\n" unless value.nil?
            end
        end
        str
    end

    private
        def parse_african(body)
            body.gsub!(/Genus/, 'Name')
            body.gsub!(/Carnivore/, 'Diet')
            body.gsub!(/Weight/, 'Weight_In_Lbs')

            body.gsub!(/,No,/, ',Herbivore,')
            body.gsub!(/,Yes,/, ',Carnivore,')

            body
        end

        def find_by_weight(weight)
            removed_nil_weights = @entries.reject {|dino| dino[:weight_in_lbs].nil?}
            results = []
            if weight.casecmp("big").zero?
                results = removed_nil_weights.select {|dino| dino[:weight_in_lbs] >= 2000}
            else
                results = removed_nil_weights.select {|dino| dino[:weight_in_lbs] < 2000}
            end
            results
        end

end
