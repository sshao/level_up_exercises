require 'csv'

class Dinodex
	attr_reader :entries

	def initialize(*filepaths)
		@entries = []

		filepaths.each do |path|
			body = File.read(path).downcase

			body = parse_african(body) if body =~ /Genus,Period,Carnivore,Weight,Walking/i

			csv = CSV.new(body, :headers => true, :header_converters => :symbol,
										:converters => :all)

			@entries.concat csv.to_a.map { |row| row.to_hash }
		end
	end

	def find(*searches)
		results = @entries.select { |dino| dino_matches_all?(dino, *searches) }
		results.map { |dino| dino[:name] }
	end

	def print_dinos(names)
		names = Array(names)

		names.each do |name|
			dino = @entries.find { |dino| dino[:name].casecmp(name).zero? }
			dino.each { |k, v| puts "#{k}: #{v}\n" unless v.nil? }
		end
	end

	private
	def parse_african(body)
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

			target = search[:targets].downcase

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
			true if carnivores.include? dino[:diet]
		else
			true if dino[:diet].casecmp(target_diet).zero?
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

