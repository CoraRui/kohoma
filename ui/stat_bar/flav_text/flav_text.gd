extends Node2D
class_name flav_text


#TODO: actually figure out how and when you are going to use this. during enemy encounters? boss fights?
#TODO: ACTUALLY USE IT!!!
#TODO: alternate with other menu items. like rupees or something that are less important

@export var main_label : Label
@export var name_label : Label
@export var char_timer : Timer


#this script controls the flavor text on the top of the screen.

func update_text(mt : String, nt : String):
	name_label.text = nt
	main_label.text = mt
