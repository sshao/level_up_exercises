require 'csv'

class DinodexError < Exception
end

class Dinodex
	attr_reader :dinos
  CSV_FORMATS = [:african, :dinodex]

	def initialize(*filepaths)
		@dinos = []

		filepaths.each do |path|
			body = File.read(path).downcase

      format = identify_format(body)
      raise DinodexError.new("Invalid CSV headers/format in #{path}.") if format.nil?
      
      parse_african_format(body) if format.eql? :african

			csv = CSV.new(body, :headers => true, :header_converters => :symbol,
										:converters => :all)

			@dinos.concat csv.to_a.map { |row| row.to_hash }
		end
	end

	def find(*searches)
		results = @dinos.select { |dino| dino_matches_all?(dino, *searches) }
		results.map { |dino| dino[:name] }
	end

	def print_dinos(names)
		names = Array(names)

		names.each do |name|
			dino = @dinos.find { |dino| dino[:name].casecmp(name).zero? }
			dino.each { |header, fact| puts "#{header}: #{fact}\n" unless fact.nil? }
		end
	end

	private
  def identify_format(body)
    return :african if body =~ /Genus,Period,Carnivore,Weight,Walking/i
    return :dinodex if body =~ /Name,Period,Continent,Diet,Weight_in_lbs,Walking,Description/i
    nil
  end

	def parse_african_format(body)
		body.gsub!(/genus/i, 'name')
		body.gsub!(/carnivore/i, 'diet')
		body.gsub!(/weight/i, 'weight_in_lbs')
		body.gsub!(/,no,/i, ',herbivore,')
		body.gsub!(/,yes,/i, ',carnivore,')

		body
	end

	def dino_matches_all?(dino, *searches)
		searches.each do |search|
			return false if dino[search[:key]].nil?

			target = search[:target].downcase

			case search[:key]
			when :weight_in_lbs
				return false unless matches_weight?(dino, target)
			when :diet
				return false unless matches_diet?(dino, target)
			else
				return false unless dino[search[:key]].include? target
			end
		end

		true
	end

	def matches_diet?(dino, target_diet)
		return false if dino[:diet].nil?

		carnivores = %w(carnivore insectivore piscivore)

		if target_diet.casecmp("carnivore").zero?
			return true if carnivores.include? dino[:diet]
		else
			return true if dino[:diet].casecmp(target_diet).zero?
		end

    false
	end

	def matches_weight?(dino, weight)
		return false if dino[:weight_in_lbs].nil?

    return dino[:weight_in_lbs] >= 2000 if weight.casecmp("big").zero?
    return dino[:weight_in_lbs] < 2000 if weight.casecmp("small").zero?

    nil
	end

end

