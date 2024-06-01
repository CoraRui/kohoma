extends Node2D
class_name camera_loader

#this autoload contains the camera, and functions for moving it.

#autoloads
@onready var level_bi : level_border = get_node("/root/level_border_auto")
@onready var world_i : world = get_node("/root/world_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")

@onready var main_window : Window = get_window()

@export var cam_vel : int = 5

@export var main_camera : Camera2D 

@onready var shift_point : Vector2 = main_camera.position

@export var snap_tol : float = 7

#size of the level. smaller than the screen cause stat bar and lower bar.
@export var level_size : Vector2i = Vector2(176, 112)

#true if the camera is currently moving
var shifting = false

signal camera_snapped



func _physics_process(_delta):
	move_camera()

func start_shift(sv : Vector2i):
	#this function should shift the camera one screen in the passed direction.
	shift_point = Vector2(Vector2(sv * level_size) + main_camera.position)
	shifting = true

func move_camera():
	if not shifting:
		return
	
	if abs(shift_point.distance_to(main_camera.position)) < snap_tol:
		shifting = false
		main_camera.position = shift_point
		level_bi.pause = false
		world_i.clear_previous_level()
		camera_snapped.emit()
		
	main_camera.position = main_camera.position.move_toward(shift_point, cam_vel)
	stat_bi.global_position = main_camera.global_position

func reset_camera():
	main_camera.position = Vector2(0,0)
	
	
	
	
	
