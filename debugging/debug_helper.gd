extends Node2D
class_name debug_helper

#contains functions to help debugging stuff.
#frinstance, contains an error message function that can be disabled from here. that way, error messages only display if
#this is active. just to avoid those messy if statements mostly and having to created a new debugging variable in the exports.
#I also want a way to categorize them. like having messages labelled certain things, and some dictionary here that tells whether
#to use that.

static var print_all : bool = false		

static var tag_dict : Dictionary = {

	"camera" : true,
	"direction" : false,
	"enemies" : false,
	"game over" : true,
	"items" : false,
	"lift" : false,
	"mechanisms" : false,
	"music" : false,
	"orb_boss" : false,
	"player" : false,
	"save/load" : false,
	"sfx_player" : false,
	"stat_bar" : false,
	"world_loader" : true,

}

static func db_message(m : String, t : String):
	#m is the message to print, t is the tag determining whether to print it.
	if tag_dict.has(t) && !print_all:
		if !tag_dict[t]:
			#this tag is disabled
			return
	else:
		print("error tag", t, "not found. printing message")
	
	print(t, " message:", m)
	
