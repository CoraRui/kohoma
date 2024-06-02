extends Node2D
class_name death_trigger

#this script should contain functions to activate the death screen.
#I guess it might as well be an autoload.

@export var game_over_ref : PackedScene

@export var game_over_mus : String

#autoloads

@onready var world_i : world = get_node("/root/world_auto")
@onready var player_i : player_loader = get_node("/root/player_loader_auto")
@onready var camera_i : camera_loader = get_node("/root/camera_loader_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var level_bi : level_border = get_node("/root/level_border_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")


func game_over():
	world_i.unload_level()
	player_i.unload_player()
	camera_i.reset_camera()
	stat_bi.death_reset()
	level_bi.reset_position()
	music_pi.play_track(game_over_mus)
	var game_over_ins : Node2D = game_over_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(game_over_ins)

