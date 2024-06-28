extends Node2D
class_name player_movement

#this script moves the player.
#should be four directional movement.

enum PlayerState {INPUT, HURT}
var player_state : PlayerState = PlayerState.INPUT

@onready var player_parent : player = get_parent()

var direction : DirClass.Dir = DirClass.Dir.DOWN :
	set(value):
		direction = value
		player_parent.direction = value

var mvec : Vector2i = Vector2i(0,0)
var hvec : Vector2i = Vector2i(0,0)

@export var pos : Node2D
@export var vel : Array[int] = [2,1]
@export var vel_index : int = 0

@export_group("areas")
@export var hit_area : Area2D
@export var up_col : Area2D
@export var down_col : Area2D
@export var left_col : Area2D
@export var right_col : Area2D
@export_group("", "")

@export var anim_controller : player_anim 

@export var hurt_timer : Timer

var frozen : bool = false

func _physics_process(_delta):
	if not frozen:
		match player_state:
			PlayerState.INPUT:
				mvec = Vector2i(0,0)
				directional_input()
				detect_collisions()
				move()
			PlayerState.HURT:
				mvec = Vector2i(0,0)
				hurt_movement()
				detect_collisions()
				move()
		
#region movement functions

func directional_input():
	#modifies the mvec vector according to the players input
	var x : int = int(Input.get_axis("left", "right"))
	var y : int = int(Input.get_axis("up", "down"))
	anim_controller.animate_movement(Vector2(x,y))
	if y == 0:
		mvec.x += vel[vel_index] * x
		if x == 1: direction = DirClass.Dir.RIGHT
		elif x == -1: direction = DirClass.Dir.LEFT
	else:
		mvec.y += vel[vel_index] * y
		if y == 1: direction = DirClass.Dir.DOWN
		elif y == -1: direction = DirClass.Dir.UP
		
		
	vel_index += 1
	if vel_index >= vel.size():
		vel_index = 0
	
func hurt_movement():
	#modifies the mvec according to hurt principles
	pass
	
func detect_collisions():
	#checks for collision and limits mvec accordingly
	if up_col.has_overlapping_bodies():
		mvec.y = clampi(mvec.y, 0, 20)
		hvec.y = clampi(hvec.y, 0, 20)
	if down_col.has_overlapping_bodies():
		mvec.y = clampi(mvec.y,-20, 0)
		hvec.y = clampi(hvec.y,-20, 0)
	if left_col.has_overlapping_bodies():
		mvec.x = clampi(mvec.x, 0, 20)
		hvec.x = clampi(hvec.x, 0, 20)
	if right_col.has_overlapping_bodies():
		mvec.x = clampi(mvec.x, -20, 0)
		hvec.x = clampi(hvec.x, -20, 0)
		
	if up_col.has_overlapping_areas():
		mvec.y = clampi(mvec.y, 0, 20)
		hvec.y = clampi(hvec.y, 0, 20)
	if down_col.has_overlapping_areas():
		mvec.y = clampi(mvec.y,-20, 0)
		hvec.y = clampi(hvec.y,-20, 0)
	if left_col.has_overlapping_areas():
		mvec.x = clampi(mvec.x, 0, 20)
		hvec.x = clampi(hvec.x, 0, 20)
	if right_col.has_overlapping_areas():
		mvec.x = clampi(mvec.x, -20, 0)
		hvec.x = clampi(hvec.x, -20, 0)
	
func move():
	#I think I want to interpret thise vector here in order to determine movement animations.
	#I'll send this vector to the player anim script. then it will be interpreted there.
	anim_controller.animate_movement(mvec)
	match player_state:
		PlayerState.INPUT:
			pos.position += Vector2(mvec)
		PlayerState.HURT:
			pos.position += Vector2(hvec) 
	
#endregion

func trigger_hurt(hpos : Vector2):
	#this function starts the movement effects for the player being hurt
	hvec = Vector2(0,0)
	player_state = PlayerState.HURT
	
	var dir_vec : Vector2 = global_position.direction_to(hpos)
	
	if abs(dir_vec.x) > abs(dir_vec.y):
		hvec.x = -1 * dir_vec.x/abs(dir_vec.x)
	else:
		hvec.y = -1 * dir_vec.y/abs(dir_vec.y)
	hurt_timer.start()
	
func freeze():
	#stops the players movement
	frozen = true
	anim_controller.animate_movement(Vector2(0,0))

func unfreeze():
	frozen = false

#region sword signals

func _on_sword_started_swing():
	freeze()

func _on_sword_ended_swing():
	unfreeze()

#endregion

func _on_hurt_timer_timeout():
	#timer for how long hurt movement should last
	player_state = PlayerState.INPUT
	hvec = Vector2(0,0)
