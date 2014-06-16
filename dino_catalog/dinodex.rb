require 'csv'

class Dinodex

    attr_reader :entries

    def initialize(filepath)
        # TODO error checking
        body = File.read(filepath)

        if body =~ /Genus,Period,Carnivore,Weight,Walking/
            body = parse_african(body)
        end

        csv = CSV.new(body, :headers => true, 
            :header_converters => :symbol,
            :converters => :all)

        @entries = csv.to_a.map{|row| row.to_hash}
    end

    private
        def parse_african(body)
            body.gsub!(/Genus/, 'Name')
            body.gsub!(/Carnivore/, 'Diet')
            body.gsub!(/Weight/, 'Weight_In_Lbs')

            body.gsub!(/,No,/, ',Non-Carnivore,')
            body.gsub!(/,Yes,/, ',Carnivore,')

            body
        end

end
