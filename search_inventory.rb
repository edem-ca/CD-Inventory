#!/usr/bin/env ruby

require './music_entry.rb'
require './json_parser.rb'

def search_inventory(field, search)

	entry_dict = get_inventory('inventory.json')

	entry_array = []

	field = field.downcase
	search = search.downcase

	entries = entry_dict.values


	# 1. obtain list of music entry objects
	# 2. obtain all mathes within the particular fields
	#
	#

	case field
	when "artist"
		entries.each do |entry|
			if entry.artist.include? search
				entry_array.push(entry)
			end
		end
		entry_array.sort! { |a,b| a.artist <=> b.artist }

	when "title"
		entries.each do |entry|
			if entry.title.include? search
				entry_array.push(entry)
			end
		end
		entry_array.sort! { |a,b| a.title <=> b.title}

	when "year"
		entries.each do |entry|
			if entry.year.include? search
				entry_array.push(entry)
			end
		end
		entry_array.sort! { |a,b| b.year <=> a.year}

	when "format"
		case search
		when "cd"
			entries.each do |entry|
				if entry.cd_count > 0
					entry_array.push(entry)
				end
			end
			entry_array.sort! { |a,b| b.cd_count <=> a.cd_count}

		when "vinyl"
			entries.each do |entry|
				if entry.vinyl_count > 0
					entry_array.push(entry)
				end
			end
			entry_array.sort! { |a,b| b.vinyl_count <=> a.vinyl_count}

		when "tape"
			entries.each do |entry|
				if entry.tape_count > 0
					entry_array.push(entry)
				end
			end
			entry_array.sort! { |a,b| b.tape_count <=> a.tape_count}
		end



	else
		puts "ERROR: Unsupported search category"

	end
	if entry_array.empty?
		puts "No search results found"
	else
		entry_array.each { |e| puts e.print_contents  }
	end

end

#script commands
field= ARGV[0]
search = ARGV[1]
search_inventory(field, search)