extends Node

#this script should prepare the game scene.

#just load in the overworld's first level for now.


@export var test_lp : Vector2i = Vector2i(0, 0)

@export var del : Node2D

@export var load_room : PackedScene

#autoloads

@onready var world_i : world = get_node("/root/world_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var pause_li : pause_loader = get_node("/root/pause_loader_auto")
@onready var save_fi : save_file = get_node("/root/save_file_auto")

#loading
@export var use_world : bool = false
@export var file_menu : Node2D

@export var sim_sel_ins : simple_select
@export var naming_group : group
@export var file_ci : file_creator

func load_world(fi : int):
	if use_world:
		world_i.draw_level_at(test_lp)
	else:
		var new_room = load_room.instantiate()
		get_tree().get_root().add_child(new_room)
		new_room.global_position += Vector2(0,-32)
	save_fi.load_file(fi)
	player_li.load_player()
	stat_bi.set_visible(true)
	pause_li.toggle_active(true)
	file_menu.queue_free()
	
func quit_game():
	get_tree().quit()

func check_file(fi : int):
	if save_fi.file_exists(fi):
		load_world(fi)
	else:
		create_file(fi)
		
func create_file(fi : int):
	sim_sel_ins.switch_group(naming_group)
	file_ci.fi = fi

func _on_file_one_activated():
	check_file(0)

func _on_file_two_activated():
	check_file(1)

func _on_file_three_activated():
	check_file(2)
