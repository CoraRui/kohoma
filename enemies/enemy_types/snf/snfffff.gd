extends Node2D



@export_group("pet!!!")
@export var pet_area : Area2D
@export var pet_sf : sf_link
var canpet : bool = false
@export_group("","")

#autoloads
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

func _input(event):
	if event.is_action_pressed("confirm") && canpet:
		sfx_pi.play_sound_link(pet_sf)
		
func _on_pet_area_area_entered(area):
	canpet = true

func _on_pet_area_area_exited(area):
	canpet = false
