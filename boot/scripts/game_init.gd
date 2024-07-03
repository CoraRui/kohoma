extends Node

#this script should prepare the game scene.

#just load in the overworld's first level for now.


@export_group("load_info")
@export var test_lp : Vector2i = Vector2i(0, 0)		#position in level tree to load in
@export var del : Node2D							#node to delete on level load
@export var load_room : PackedScene					#room to load on level load?
@export var use_world : bool = false				#indicates whether to load the new level by tree or by room.
@export var file_menu : Node2D						#uh, i think this is just for the file menu to queue it free.
													#i should just have an array of nodes to free. or something.
													#depends on what im going to end up using this script for.
													#if its just file select and game over, then whatever.
@export var sim_sel_ins : simple_select				#looks like the game init was wrapped up with some functionality for 
													#the file select screens buttons/file loading. should probably move 
													#this kind of stuff somewhere else.
@export var naming_group : group					#more file select stuff. pretty sure this is the letters for naming the player.
@export var file_ci : file_creator					#more file stuff...

@export var basic_load : bool = false				#if true, just uses enter and immediately loads in the next world.
													#mostly a placeholder for a more comprehensive "game over" system.
													#is some text going to appear? a certain track going to play?
													#some kind of advancing text system? thats for later. soon actually.
													
#region autoloads

@onready var world_i : world = get_node("/root/world_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var pause_li : pause_loader = get_node("/root/pause_loader_auto")
@onready var save_fi : save_file = get_node("/root/save_file_auto")

#endregion


func _input(event):
	if event.is_action_pressed("start") && basic_load:
		load_world(save_fi.file_index)

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
