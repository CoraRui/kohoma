extends Node2D

#this script should add a key to the players inventory.
#I'm assuming that will just add a key to the players file.
#then whatever "door" script I have will have its own save file 
#that will save that you opened it, and take one key away.

#TODO: each key placed in a dungeon/ in the world should be unique. should update to the save file as picked up
#with a unique identity tag

@export var pickup_sfx : String = "proto_jingle"
@export var save_flag : String = "dungeon_x_key_x"

#autoloads
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")

func _ready():
	if save_fi.current_file.event_dict.has(save_flag):
		if save_fi.current_file.event_dict[save_flag]:
			queue_free()

func pick_up():
	save_fi.current_file.keys += 1
	save_fi.current_file.event_dict[save_flag] = true
	stat_bi.update_key_count()
	queue_free()

func _on_key_area_area_entered(_area):
	sfx_pi.play_sound(pickup_sfx)
	pick_up()
