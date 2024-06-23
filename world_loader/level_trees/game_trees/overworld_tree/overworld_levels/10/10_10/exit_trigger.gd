extends Node2D

#this trigger should reload the last level from the grid.

@export var overworld_track : String

@export var room_ins : Node2D

@export var exit_pos : Vector2

@export var exit_timer : Timer

#autoloads

@onready var world_i : world = get_node("/root/world_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var save_mi : save_file = get_node("/root/save_file_auto")
@onready var camera_mi : camera_loader = get_node("/root/camera_loader_auto")
@onready var level_bi : level_border = get_node("/root/level_border_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var curtain_mi : curtain_module = get_node("/root/curtain_module_auto")

func exit_room():
	room_ins.queue_free()
	world_i.draw_level_at(exit_pos)
	for n in world_i.current_level.get_children():
		if n is load_info:
			player_li.player_ins.global_position = n.player_spawn[0].global_position
	music_pi.play_track(overworld_track)
	level_bi.toggle_border.call_deferred(true)
	
func _on_exit_area_area_entered(_area):
	exit_timer.start()
	curtain_mi.init_shift()
	player_li.player_ins.set_movement(false)

func _on_exit_timer_timeout():
	exit_room()
