extends Node2D

#the whale should move in the water tv logo style.
#at certain intervals, it will stop momentarily and shoot a water droplet.
#should telegraph that action in some way. likely by animating a droplet above itself.


enum WhaleState{MOVE, CHARGE, SHOOT}
var whale_state : WhaleState = WhaleState.MOVE 

@export_group("states")
@export var move_timer : Timer				#timer for duration of movestate
@export var charge_timer : Timer			#duration of charge_state
@export var shoot_timer : Timer				#duration of shoot_state
@export_group("","")

@export_group("bubble")
@export var water_ref : PackedScene			#ref to bubble projectile node
@export var bubble_anim : AnimatedSprite2D	
@export var drop_del : float = 4			#delay between shots in frames
@export_group("","")

@export_group("movement")
#TODO: add random variation to the move stated
@export var move_var : float				#variation of movestate
var mvec : Vector2 = Vector2(1,1)
var fdel : int = 0
@export_group("","")

#autoloads
@onready var world_i : world = get_node("/root/world_auto")

#region frame_processes
func _ready():
	move_timer.start()
	whale_state = WhaleState.MOVE

func _physics_process(_delta):
	match whale_state:
		WhaleState.MOVE:
			move()
		WhaleState.CHARGE:
			pass
		WhaleState.SHOOT:
			pass

#endregion

func move():
	if fdel > 0:
		position += mvec
		fdel = 0
	else: 
		fdel += 1
	
func shoot():
	var new_bubble = water_ref.instantiate()
	world_i.current_level.add_child(new_bubble)
	new_bubble.global_position = bubble_anim.global_position

#region collision_signals

func _on_top_area_entered(_area):
	mvec.y = 1

func _on_bottom_area_entered(_area):
	mvec.y = -1

func _on_left_area_entered(_area):
	mvec.x = 1

func _on_right_area_entered(_area):
	mvec.x = -1

func _on_top_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	mvec.y = 1

func _on_bottom_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	mvec.y = -1

func _on_left_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	mvec.x = 1

func _on_right_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	mvec.x = -1

#endregion

#region move_state_signals

func _on_move_timer_timeout():
	whale_state = WhaleState.CHARGE
	charge_timer.start()
	bubble_anim.play("charge")

func _on_charge_timer_timeout():
	whale_state = WhaleState.SHOOT
	shoot_timer.start()
	bubble_anim.play("none")
	shoot()

func _on_shoot_timer_timeout():
	whale_state = WhaleState.MOVE
	move_timer.start()

#endregion
