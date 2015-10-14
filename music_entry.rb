#!/usr/bin/env ruby

require 'json'

class MusicEntry

 	#used for easy searching in search_inventory.rb
 	attr_reader :artist, :title, :year, :id_slug, :cd_count, :tape_count, :vinyl_count

 	#music_entry object initializer
	def initialize(artist, title, year)
		@artist = artist.downcase
		@title = title.downcase
		@year = year

		#for use in hashmaps as a unique ID
		@id_slug = @artist + "|" + @title + "|" + @year

		@cd_count ||= 0
		@cd_id = @id_slug + "|cd"

		@tape_count ||= 0
		@tape_id = @id_slug+ "|tape"

		@vinyl_count ||= 0
		@vinyl_id = @id_slug+ "|vinyl"
	end

	# I decided to abstract out the intitialization of inventory it handles .pipe and .csv equally
	# If a transaction results in < 0 stock you get an error before its processed

	def update_inventory(format, amount)
		case format.downcase
		when "cd"
			if (@cd_count + amount) >= 0
				@cd_count += amount
			else
				puts "ERROR: Not enough stock"
			end
		when "tape"
			if (@tape_count + amount) >= 0
				@tape_count += amount
			else
				puts "ERROR: Not enough stock"
			end
			
		when "vinyl"
			if (@vinyl_count + amount) >= 0
				@vinyl_count += amount
			else
				puts "ERROR: Not enough stock"
			end
		else
			puts "Incompatible Music Format"
		end
	end
    
    #custom getter method for purchase.rb
	def get_stock(format)
		case format.downcase
			when "cd"
				@cd_count
			when "vinyl"
				@vinyl_count
			when "tape"
				@tape_count
			else
				puts "ERROR: janky format"
		end
	end



	#string representation of an entry
	def print_contents
		puts "Artist: %s" % [@artist]
		puts "Album: %s" % [@title]
		puts "Released: %s" % [@year]

		if @cd_count > 0
		puts "CD(%d): %s" % [@cd_count, @cd_id]
		end

		if @tape_count > 0
		puts "Tape(%d): %s" % [@tape_count, @tape_id]
		end

		if @vinyl_count > 0
		puts "Vinyl(%d): %s" % [@vinyl_count, @vinyl_id]
		end

	end

	#json object serializer
	def to_json_object
		hash = {}
        self.instance_variables.each do |var|
            hash[var] = self.instance_variable_get var
        end
        hash.to_json
	end
end



