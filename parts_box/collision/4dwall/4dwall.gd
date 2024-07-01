extends Node2D


#should hold 4 areas (udlr) and have signals related to them attached to this node.
#how to i connect those? do I just connect the signals to this object, then have new signals here that fire when those signals fire?
#i think thatd be best. what about layers? i don't wanna have to do editable children.
#i dunno if it can tell by string. i guess i could just have an exported int. but will the setters/getters even be able to handle that?
#honestly editable children will probably be less of a pain.

#what about body vs area? i dont think it really matters but i can just have a boolean export
#although i probably almost always want both.

@export_group("area parameters")
@export var area_arr : Array[Area2D]
@export var detect_body : bool = true
@export var detect_area : bool = true
#i dont wanna have to do a bunch of complicated shit. just gonna look at indexes manually
@export var collision_layers : Array[int]	#any int included here is an active layer.
@export var collision_mask : Array[int]
@export_group("","")

#region signals

#ok. so the parameters are ducktyped. meaning that you can emit the signals without putting in the parameters.
#which is fine but it also means that youll need to make sure to check for which is there in the functions
#those signals connect to, and to send the proper things in the signals here when emitted.

signal up_enter(body : PhysicsBody2D, area : Area2D)
signal down_enter(body : PhysicsBody2D, area : Area2D)
signal left_enter(body : PhysicsBody2D, area : Area2D)
signal right_enter(body : PhysicsBody2D, area : Area2D)

signal up_exit(body : PhysicsBody2D, area : Area2D)
signal down_exit(body : PhysicsBody2D, area : Area2D)
signal left_exit(body : PhysicsBody2D, area : Area2D)
signal right_exit(body : PhysicsBody2D, area : Area2D)

#endregion

func _ready():
	init_layers()
	
func init_layers() -> void:
	#iterate through layers and mask to set values of each area.
	
	#clear all of the layers
	for i in 32:
		for j in 3:
			area_arr[j].set_collision_layer_value(i,false)
			area_arr[j].set_collision_mask_value(i,false)
	
	#copy layer and mask values to all areas
	for l in collision_layers:
		for j in 3:
			area_arr[j].set_collision_layer_value(l,true)
		
	for m in collision_mask:
		for j in 3:
			area_arr[j].set_collision_mask_value(m,true)

#region area signals

func _on_top_area_area_entered(area : Area2D):
	if !detect_area:
		return
	
	up_enter.emit(area)

func _on_top_area_body_entered(body : PhysicsBody2D):
	if !detect_body:
		return
	
	up_enter.emit(body)

func _on_bottom_area_area_entered(area : Area2D):
	if !detect_area:
		return
	
	down_enter.emit(area)

func _on_bottom_area_body_entered(body : PhysicsBody2D):
	if !detect_body:
		return
	
	down_enter.emit(body)

func _on_left_area_area_entered(area : Area2D):
	if !detect_area:
		return
	
	left_enter.emit(area)

func _on_left_area_body_entered(body : PhysicsBody2D):
	if !detect_body:
		return
	
	left_enter.emit(body)

func _on_right_area_area_entered(area : Area2D):
	if !detect_area:
		return
	
	right_enter.emit(area)

func _on_right_area_body_entered(body : PhysicsBody2D):
	if !detect_body:
		return
	
	right_enter.emit(body)

func _on_top_area_area_exited(area : Area2D):
	if !detect_area:
		return
	
	up_exit.emit(area)

func _on_bottom_area_area_exited(area : Area2D):
	if !detect_area:
		return
	
	down_exit.emit(area)

func _on_left_area_area_exited(area : Area2D):
	if !detect_area:
		return
	
	left_exit.emit(area)

func _on_right_area_area_exited(area : Area2D):
	if !detect_area:
		return
	
	right_exit.emit(area)

func _on_top_area_body_exited(body : PhysicsBody2D):
	if !detect_body:
		return
	
	up_exit.emit(body)

func _on_bottom_area_body_exited(body : PhysicsBody2D):
	if !detect_body:
		return
	
	down_exit.emit(body)

func _on_left_area_body_exited(body : PhysicsBody2D):
	if !detect_body:
		return
	
	left_exit.emit(body)

func _on_right_area_body_exited(body : PhysicsBody2D):
	if !detect_body:
		return
	
	right_exit.emit(body)

#endregion
