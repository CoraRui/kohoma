extends Node2D
class_name player

#collects information for other scripts to reference to avoid having to access children.

var direction : DirClass.Dir = DirClass.Dir.DOWN

@export var items_node : items
@export var movement_script : player_movement
@export var sword_script : sword
@export var anim_script : player_anim

func set_movement(f : bool):
	if f:
		movement_script.unfreeze()
	else:
		movement_script.freeze()

func set_sword_active(s : bool):
	sword_script.set_sword_active(s)

