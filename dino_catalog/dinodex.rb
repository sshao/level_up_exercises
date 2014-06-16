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
