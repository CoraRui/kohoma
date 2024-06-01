extends Node2D


#TODO: update sound effect

#autoloads
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

@export var value : int = 1

@export var pickup_sn : String = "def_pickup"

func add_coin():
	save_fi.current_file.gold += value
	sfx_pi.play_sound(pickup_sn)
	queue_free()

func _on_coin_area_area_entered(_area):
	add_coin()
