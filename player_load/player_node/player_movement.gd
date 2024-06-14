extends Node2D
class_name player_movement

#this script moves the player.
#should be four directional movement.

@onready var player_parent : player = get_parent()

var direction : DirClass.Dir = DirClass.Dir.DOWN :
	set(value):
		direction = value
		player_parent.direction = value
		
var mvec : Vector2i = Vector2i(0,0)

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

var frozen : bool = false

func _physics_process(_delta):
	if not frozen:
		mvec = Vector2i(0,0)
		directional_input()
		detect_collisions()
		move()

func directional_input():
	var x : int = int(Input.get_axis("left", "right"))
	var y : int = int(Input.get_axis("up", "down"))
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
	
func detect_collisions():
	if up_col.has_overlapping_bodies():
		mvec.y = clampi(mvec.y, 0, 20)
	if down_col.has_overlapping_bodies():
		mvec.y = clampi(mvec.y,-20, 0)
	if left_col.has_overlapping_bodies():
		mvec.x = clampi(mvec.x, 0, 20)
	if right_col.has_overlapping_bodies():
		mvec.x = clampi(mvec.x, -20, 0)
	
func move():
	#I think I want to interpret thise vector here in order to determine movement animations.
	#I'll send this vector to the player anim script. then it will be interpreted there.
	anim_controller.animate_movement(mvec)
	pos.position += Vector2(mvec)

func freeze():
	#stops the players movement
	frozen = true
	anim_controller.animate_movement(Vector2(0,0))

func unfreeze():
	frozen = false

func _on_sword_started_swing():
	freeze()

func _on_sword_ended_swing():
	unfreeze()
