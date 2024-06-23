extends Node2D
class_name camera_loader

#this autoload contains the camera, and functions for moving it.
#TODO: redesign scrolling movement system to center levels at origin to simplify working with level positioning stuff.


@onready var main_window : Window = get_window()

@export var cam_vel : int = 5

@export var main_camera : Camera2D 

@onready var shift_point : Vector2 = main_camera.position

@export var snap_tol : float = 2

#size of the level. smaller than the screen cause stat bar and lower bar.
@export var level_size : Vector2i = Vector2(176, 112)

#true if the camera is currently moving
var shifting = false
var player_shifting = false
var player_point : Vector2

signal camera_snapped

#autoloads
@onready var level_bi : level_border = get_node("/root/level_border_auto")
@onready var world_i : world = get_node("/root/world_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var pause_li : pause_loader = get_node("/root/pause_loader_auto")
@onready var curtain_mi : curtain_module = get_node("/root/curtain_module_auto")

func _physics_process(_delta):
	move_camera()
	shift_player()

func start_shift(sv : Vector2i):
	#this function should shift the camera one screen in the passed direction.
	shift_point = Vector2(Vector2(sv * level_size) + main_camera.position)
	shifting = true
	
	#freeze players movement, move them over into next screen. like 20px
	player_li.player_ins.set_movement(false)
	player_li.player_ins.set_sword_active(false)
	pause_li.toggle_active(false)
	player_shifting = true
	player_point = player_li.player_ins.global_position + (Vector2(sv) * 13)

func move_camera():
	if not shifting:
		return
	if abs(shift_point.distance_to(main_camera.position)) < snap_tol:
		end_shift()
	main_camera.position = main_camera.position.move_toward(shift_point, cam_vel)
	stat_bi.global_position = main_camera.global_position - Vector2(88, 64)
	curtain_mi.global_position = main_camera.global_position - Vector2(88, 64)
	
func shift_player():
	if not player_shifting:
		return
	player_li.player_ins.global_position = player_li.player_ins.global_position.move_toward(player_point, 1)
	if player_li.player_ins.global_position.distance_to(player_point) < snap_tol:
		player_li.player_ins.global_position = player_point
		player_shifting = false
	
func end_shift():
	shifting = false
	main_camera.position = shift_point
	level_bi.pause = false
	world_i.clear_previous_level()
	camera_snapped.emit()
	player_li.player_ins.set_movement(true)
	player_li.player_ins.set_sword_active(true)
	pause_li.toggle_active(true)
	
func reset_camera():
	main_camera.position = Vector2(88,64)
	
	
