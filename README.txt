Review
__________

Here is my submission for the SYPartners coding exercise. 

Design Overview
___________

The program runs off of 3 commands per your request
1. ruby load_inventory <file>
2. ruby search inventory <field> <search>
3. ruby purchase <identifier>

All three of these functions work off of a music_entry.rb, that contains getter and setter methods for 
various attributes of an entry in inventory.

The music_entry class (and each instance of it) has
	1) artist, title, year -> what makes each entry unique
	2) custom id that is comprised of artist, title and year separated by pipes "|" -> used in hashes
	3) counts and id slugs for cds, tapes, and vinyl records -> stock formats
	4) json serializer
	5) print contents function -> a glorified to_s

All three scripts use json_parser.rb, which is effectively an API of sorts,
hence the GET and POST methods. Json_parser converts/serializes ruby dicitonaries <==> json objects,
and writes out to a file (a pseudo DB) - defaulted to inventory.json. 
When this scales up connecting to a real API or external DB this should be relatively easy to set up. 

Before any of the 3 scripts run, they retrieve the current inventory from inventory.json, convert it
to a ruby dict, run whatever functions they need to, and write the updated inventory to 
inventory.json.

Right now, the way to clear all the inventory is to input any ".txt" file into load_inventory.
I used it for testing and I decided to keep that functionality in load_inventory. 

The identifier is in the format
<artist>|<album title|<year|<format>

Example:
Artist: pink floyd
Album: the dark side of the moon
Released: 1973
CD(3): pink floyd|the dark side of the moon|1973|cd

Which means that when using purchase you will need to escape characters for spaces, pipes, or other special
characters in terminal

So

$ ruby purchase pink floyd|the dark side of the moon|1973|cd

will become 

$ ruby purchase pink\ floyd\|the\ dark\ side\ of\ the\ moon\|1973\|cd

All inputs/outputs are handled as lowercase to prevent case issues, hashing to different things

You can search for all cds, vinyls, or tapes in stock, and the search will return all items in stock in decending order

When an item is out of stock in all formats I figured it was better to have the artist-title-year persist in the inventory, so you know whats missing. 

Shortcomings / TODOs
________

If I had more time to work on this further I would work on the following

-Handling incorrect file input formats, 
currently it works on good faith that the prompt will give correctly formatted files

-Handling "strange" inputs - ie. bands or albums that contain funky characters particularly pipes,
because they are used in ID slugs for various maps. Beyond the command line escaping, it could potentially 
mess up JSON parsing if fields contain colons or curly brackets.

-Abstracting out procs or blocks in load_inventory - The code is repetitive when creating new music entries

-Find a better regular expression to parse out when the first item in a CSV is in quotes. 

____

Hope to hear from you guys soon!

Edem :D