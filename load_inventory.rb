#!/usr/bin/env ruby

require './music_entry.rb'
require './json_parser.rb'



def load_inventory(filename)

	entry_dict = get_inventory('inventory.json')

	file_extension = File.extname(filename)

	#load the input file different based on .csv, .pipe, or .txt formats
	case file_extension
		when ".csv"
			File.foreach(filename) {|line| 

				#handle the "peter, paul, and mary" case with commas inside an artists name
				if line.strip.include? "\""

					#parsing the file to constituent parts to create a music_entry object
					inter = line.strip.split(/"([^"]*)"/)
					fields = inter[2].downcase.split(',')
					artist = inter[1].downcase.strip
					title = fields[1]
					format = fields[2]
					year = fields[3]
					id_slug = artist + "|" + title + "|" + year

					#if the item is in the dicitonary, just update the stock, if not make a new inventory entry
					if entry_dict.key?(id_slug) 
						entry_dict[id_slug].update_inventory(format, 1)

					else
						entry = MusicEntry.new(artist, title, year)
						entry.update_inventory(format, 1)
						entry_dict[id_slug] = entry

					end

				else

					fields = line.downcase.strip.split(',')
					artist = fields[0]
					title = fields[1]
					format = fields[2]
					year = fields[3]
					id_slug = artist + "|" + title + "|" + year

					if entry_dict.key?(id_slug) 
						entry_dict[id_slug].update_inventory(format, 1)

					else
						entry = MusicEntry.new(artist, title, year)
						entry.update_inventory(format, 1)
						entry_dict[id_slug] = entry

					end


				end
		
		
	}


		when ".pipe"
			File.foreach(filename) {|line| fields = line.strip.split('|')

				artist = fields[3].strip.downcase
				title = fields[4].strip.downcase
				year = fields[2].strip.downcase
				amount = fields[0].strip.downcase.to_i
				format = fields[1].strip.downcase
				id_slug = artist + "|" + title + "|" + year
				

				if entry_dict.key?(id_slug) 
					entry_dict[id_slug].update_inventory(format, amount)

				else
					entry = MusicEntry.new(artist, title, year)
					entry.update_inventory(format, amount)
					entry_dict[id_slug] = entry
				
				end
		
	}
		#cute little hack for clearing up inventory.json
		when ".txt"
			entry_dict.clear
			puts "Cleared Inventory"

		else
			puts "ERROR: Incorrect File Format"

		end

	post_inventory(entry_dict, 'inventory.json')

end

#script commands
file = ARGV[0]
load_inventory(file)


