extends Node2D
class_name level_border


#TODO: player position lock on level load, move them into the next level, and lock their movement until camera snap

#this script(autoload?) contains the instructions for what to do with the stage border signals.
#I assume that I'll reference other autoloads in order to load in and out certain things?
#so does that just mean that I connect the four signals here then work it out that way?
#i think so.

#autoloads

@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var world_i : world = get_node("/root/world_auto")
@onready var camera_li : camera_loader = get_node("/root/camera_loader_auto")

#parameters

@export var level_size : Vector2 = Vector2(176, 112)

#internals

#set to true while the scene is moving
var pause : bool = false

func toggle_border(p : bool):
	pause = not p

func shift_level(sv : Vector2i):
	if pause:
		return
	world_i.draw_level_adj(sv)
	camera_li.start_shift(sv)
	pause = true
	global_position += Vector2(sv) * level_size

func reset_position():
	position = Vector2(0, 0)

#area signals

func _on_left_area_area_entered(_area):
	shift_level(Vector2i(-1,0))

func _on_right_area_area_entered(_area):
	shift_level(Vector2i(1,0))

func _on_top_area_area_entered(_area):
	shift_level(Vector2i(0,-1))
	
func _on_bottom_area_area_entered(_area):
	shift_level(Vector2i(0,1))

