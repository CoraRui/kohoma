extends Node2D
class_name pause_loader

#TODO: pause menu should load in at current camera position

#this autoload waits for a button press and loads the main menu
@export_file var pause_menu_ref : String = "res://ui/pause_menu/nodes/pause_menu.tscn"
var pause_mi : Node2D

@export_file var inventory_menu_ref : String = "res://"
var inventory_mi : Node2D

@export var pause_active : bool = false

#autoloads

@onready var world_i : world = get_node("/root/world_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var level_bi : level_border = get_node("/root/level_border_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var camera_li : camera_loader = get_node("/root/camera_loader_auto")

func _input(event):
	if not pause_active:
		return
	if event.is_action_pressed("start"):
		if not pause_mi:
			open_pause_menu()
		else:
			close_pause_menu()
	if event.is_action_pressed("select"):
		if not inventory_mi:
			if pause_mi:
				close_pause_menu()
			open_inventory_menu()
		else:
			close_inventory_menu()	
			


func open_pause_menu():
	world_i.set_process(false)
	player_li.set_process(false)
	level_bi.set_process(false)
	stat_bi.set_process(false)
	world_i.set_visible(false)
	player_li.set_visible(false)
	level_bi.set_visible(false)
	stat_bi.set_visible(false)
	pause_mi = load(pause_menu_ref).instantiate()
	get_tree().get_root().add_child(pause_mi)
	pause_mi.global_position = camera_li.main_camera.global_position

func open_inventory_menu():
	world_i.set_process(false)
	player_li.set_process(false)
	level_bi.set_process(false)
	stat_bi.set_process(false)
	world_i.set_visible(false)
	player_li.set_visible(false)
	level_bi.set_visible(false)
	stat_bi.set_visible(false)
	inventory_mi = load(inventory_menu_ref).instantiate()
	get_tree().get_root().add_child(inventory_mi)
	inventory_mi.global_position = camera_li.main_camera.global_position

func close_inventory_menu():
	world_i.set_process(true)
	player_li.set_process(true)
	level_bi.set_process(true)
	stat_bi.set_process(true)
	world_i.set_visible(true)
	player_li.set_visible(true)
	level_bi.set_visible(true)
	stat_bi.set_visible(true)
	inventory_mi.queue_free()

func close_pause_menu():
	world_i.set_process(true)
	player_li.set_process(true)
	level_bi.set_process(true)
	stat_bi.set_process(true)
	world_i.set_visible(true)
	player_li.set_visible(true)
	level_bi.set_visible(true)
	stat_bi.set_visible(true)
	pause_mi.queue_free()

func toggle_active(b : bool):
	pause_active = b
