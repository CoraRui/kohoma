extends Node2D
class_name flav_trigger


#this script triggers a change in the flav_text.


@export var flav_name : String = "octo"

@export var flav_main : String = "blub, blub."

#autoload
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")


func update_flav_text():
	stat_bi.update_flav_text(flav_main, flav_name)

func _on_player_area_area_entered(_area):
	update_flav_text()

#
func _on_health_hurt():
	update_flav_text()
