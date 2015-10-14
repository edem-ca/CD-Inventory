#!/usr/bin/env ruby

#makeshift API (GET/POST requests) that also writes to a json file that keep track of inventory
require './music_entry.rb'
require 'json'



def get_inventory(inventory_file)
	inventory_dict = {}

	#parse JSON map
	json_inventory_string = File.read(inventory_file)
	json_hash = JSON.parse(json_inventory_string)
	entries = json_hash.values

	entries.each do |entry|

		#inventory.json is actually a map of maps of objects, so we need to parse again
		entry = JSON.parse(entry)

		#parses JSON and maps it to a music_entry object
		artist = entry["@artist"]
		title = entry["@title"]
		year = entry["@year"]
		cds = entry["@cd_count"].to_i
		tapes = entry["@tape_count"].to_i
		vinyls = entry["@vinyl_count"].to_i
		id_slug = artist + "|" + title + "|" + year

		inventory_entry = MusicEntry.new(artist, title, year)
		inventory_entry.update_inventory("cd", cds)
		inventory_entry.update_inventory("vinyl", vinyls)
		inventory_entry.update_inventory("tape", tapes)

		inventory_dict[id_slug] = inventory_entry

	end

	return inventory_dict
end

def post_inventory(inventory_dict, output_file)

	json_dict = {}
	entries = inventory_dict.values

	#get each object in JSON form, and add it to a dict
	entries.each do |entry|
		
		json_dict[entry.id_slug] = entry.to_json_object

	end

	#turn that map of objects into a JSON object
	File.open(output_file, "w") { |file| 

		file.write(JSON.pretty_generate(json_dict))
	}

	return output_file
end

