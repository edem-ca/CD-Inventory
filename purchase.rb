#!/usr/bin/env ruby

require './music_entry.rb'
require './json_parser.rb'


def purchase(id)

	entry_dict = get_inventory('inventory.json')

	#parse unique ID string
	terms = id.downcase.strip.split("|")

	#you've seen this before
	artist = terms[0]
	title = terms[1]
	year = terms[2]
	format = terms[3]
	id_slug = artist + "|" + title + "|" + year
	
	if entry_dict.has_key? id_slug

		previous_stock = entry_dict[id_slug].get_stock(format)
		entry_dict[id_slug].update_inventory(format, -1)
		current_stock = entry_dict[id_slug].get_stock(format)

		#we know it worked if the inventory is different from before
		#If it fails, update_inventory will throw the out of stock error
		if previous_stock != current_stock
			puts "Removed 1 %s of %s by %s from the inventory" % [format, title, artist]
		end

	else

		puts "ERROR: Entry not found in inventory. Ensure your id is in the correct format"
	end

	post_inventory(entry_dict, 'inventory.json')
end

#script commands
id = ARGV[0]
purchase(id)

