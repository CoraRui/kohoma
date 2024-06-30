extends Node2D

#this script should destroy the door when its unlocked(eventually use some sort of animation)
#it should also use the save file to update that the door is locked/unlocked with a unique save_key


#TODO: sfx and animation on unlock

@export_group("save_info")
@export var save_flag : String = "dungeon_x_door_x"
@export_group("","")

#autoloads
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")

func _ready():
	#check the save file for the flag for this door
	if save_fi.current_file.event_dict.has(save_flag):
		if save_fi.current_file.event_dict[save_flag]:
			queue_free()
		
func _on_unlock_area_area_entered(_area):
	if save_fi.current_file.keys <= 0:
		print("no keys to unlock door")
		return
	save_fi.current_file.keys -= 1
	stat_bi.update_key_count()
	save_fi.current_file.event_dict[save_flag] = true
	queue_free()
