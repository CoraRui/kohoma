extends Node2D


#this node should change the scene to a single room temporarily.
#hopefully its structured in a way that allows me to chain a few of these together.

var room_ins : Node2D

@export var room_ref : PackedScene

@export var room_track : String

#spawn index for the player
@export var player_si : int = 0

#autoloads
@onready var world_i : world = get_node("/root/world_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var save_mi : save_file = get_node("/root/save_file_auto")
@onready var camera_mi : camera_loader = get_node("/root/camera_loader_auto")
@onready var level_bi : level_border = get_node("/root/level_border_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")

func load_room():
	camera_mi.reset_camera()
	level_bi.reset_position()
	level_bi.toggle_border(false)
	world_i.unload_level()
	world_i.reset_position()
	room_ins = room_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(room_ins)
	stat_bi.reset_position()
	
	for c in room_ins.get_children():
		if c is load_info:
			player_li.player_ins.global_position = c.player_spawn[player_si].global_position
	
	music_pi.play_track(room_track)

func _on_rt_area_area_entered(_area):
	load_room()
