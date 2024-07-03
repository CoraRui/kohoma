extends Node2D
class_name player

#TODO: turn animation when against wall without moving

#collects information for other scripts to reference to avoid having to access children.

var direction : DirClass.Dir = DirClass.Dir.DOWN

#region exports

@export_group("move_to parameters")
@export var move_speed : int = 2		#how many pixels to move the character per frame
@export var snap_tol : int = 3
var shift_vec : Vector2
var shift_index : int = 0
@export_group("","")

@export_group("node refs")
@export var items_node : items
@export var movement_script : player_movement
@export var sword_script : sword
@export var anim_script : player_anim
@export var health_script : player_health
@export var lift_script : player_lift
@export_group("","")

#endregion

func _physics_process(_delta):
	move_to_frame()

func set_movement(f : bool):
	if f:
		movement_script.unfreeze()
	else:
		movement_script.freeze()

func set_sword_active(s : bool):
	sword_script.set_sword_active(s)

func set_items_active(b : bool) -> void:
	#toggles whether items can be used.
	items_node.toggle_items(b)

func move_to_frame():
	if shift_index <= 0:
		return
	global_position = global_position + shift_vec
	shift_index -= 1

func shift_by(sv : Vector2, dist : int):
	#this function accepts a directional vector and an index.
	#it shifts the player in the direction of that vector the amount of times in the index.
	shift_vec = sv
	shift_index = dist
