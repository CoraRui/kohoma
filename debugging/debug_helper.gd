extends Node2D
class_name debug_helper

#contains functions to help debugging stuff.
#frinstance, contains an error message function that can be disabled from here. that way, error messages only display if
#this is active. just to avoid those messy if statements mostly and having to created a new debugging variable in the exports.
#I also want a way to categorize them. like having messages labelled certain things, and some dictionary here that tells whether
#to use that.

@export var print_all : bool = false		

@export var tag_dict : Dictionary			#dictionary boolean value, string keys. determines whether to print messages with that tag.

func db_message(m : String, t : String):
	#m is the message to print, t is the tag determining whether to print it.
	if tag_dict.has(t) && !print_all:
		if !tag_dict[t]:
			#this tag is disabled
			return
	else:
		print("error tag", t, "not found. printing message")
	
	print(t, " message:", m)
	
