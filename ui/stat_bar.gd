extends Node2D
class_name stat_bar


#TODO: key icon
#TODO: flavor text dialogue box
#TODO: flavor text empty state
#TODO: add map?


@export var hp_bar : heart_bar

@export var flav : flav_text

@export var key_label : Label

@onready var save_fi : save_file = get_node("/root/save_file_auto")

func _ready():
	update_health(save_fi.current_file.hp, save_fi.current_file.mhp)
	update_key_count()
	set_visible(false)

func update_health(hp, mhp):
	hp_bar.write_hp(hp, mhp)

func update_key_count():
	key_label.text = str(save_fi.current_file.keys)

func update_flav_text(mt : String, nt : String):
	flav.update_text(mt, nt)

func death_reset():
	position = Vector2(0,0)
	#should eventually get health from save file. or the player? no, save file.
	update_health(save_fi.current_file.hp, save_fi.current_file.mhp)

func reset_position():
	global_position = Vector2(0,0)
