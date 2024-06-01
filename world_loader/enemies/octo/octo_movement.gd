extends Node2D

#TODO: delay death until knockback impact
#TODO: actually make them fucking launch boulders
#TODO: proper movement, wall collisions, directional
#so two things for collisions:
#check during the next move function to make sure that there arent any walls in the way of the direction of movement
#if the area detects a wall, reverse or change the direction of movement away from the wall
#TODO: weighted behavior, such as pursuing the player more often, directing shots toward player etc.
#TODO: adjust knockback its wayyyy to heavy also other movement stuff
#TODO: animations: movement by direction, attacking, hurt, etc.
#TODO: sfx: hit, shoot, KO

#ok. so the most basic idea of the script is that theres an mvec that is used to change the position of the octo once per frame.
#I'm probably going to use a similar principle for other movement scripts. But point is, that's not too much to reproduce.

#these states refer to the octos current state. different patterns of movement exist for each state, which cause the enemy to behave completely differently in each state.
enum MovementState {MOVING, HURT, KO, STUN}

enum MDir {UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3}

var octo_state : MovementState = MovementState.MOVING

var octo_dir : MDir = MDir.DOWN

@export var enemy_node : Node2D

@export var vel : int

@export var wall_areas : Array[Area2D]

@export_group("timers")
@export var move_timer : Timer
@export var stun_timer : Timer
@export_group("","")

@export_group("animation")
@export var octo_anim : AnimatedSprite2D
@export_group("","")

#multiplier for knockback speed
@export var kbvel : int

#autoloads
@onready var player_li : player_loader = get_node("/root/player_loader_auto")

#internals
var mvec : Vector2 = Vector2(0,0)
var hvec : Vector2 = Vector2(0,0)

func _ready():
	next_move()

func _physics_process(_delta):
	move()
	
func next_move():
#ok. this function calculates prob for a turn in some direction.
#the directions get added up and used as weights for probability
	var up : int = 25
	var down : int = 25
	var left : int = 25
	var right : int = 25
	
	var tot : int = up + down + left + right
	
	var r : int = randi_range(0, tot)
	r -= up
	if r < 0:
		set_direction(MDir.UP)
		r += 1000
	r -= down
	if r < 0:
		set_direction(MDir.DOWN)
		r+= 1000
	r -= left
	if r < 0:
		set_direction(MDir.LEFT)
		r += 1000
	r -= right
	if r < 0:
		set_direction(MDir.RIGHT)
		r += 1000
		
	move_timer.start()

func move():
	if octo_state == MovementState.MOVING:
		enemy_node.global_position += mvec
		if mvec.x != 0 && mvec.y != 0:
			print(mvec)
	elif octo_state == MovementState.HURT:
		enemy_node.global_position += hvec
	elif octo_state == MovementState.STUN:
		#TODO: possibly add some sort of stunned movement pattern? but they can just be still for now.
		pass

func set_direction(ndir : MDir):
	#account for hurt direction?
	if ndir == MDir.UP:
		mvec = Vector2(0,-1)
		octo_anim.rotation = deg_to_rad(180)
		octo_dir = MDir.UP
	elif ndir == MDir.DOWN:
		mvec = Vector2(0,1)
		octo_anim.rotation = deg_to_rad(0)
		octo_dir = MDir.DOWN
	elif ndir == MDir.LEFT:
		mvec = Vector2(-1,0)
		octo_anim.rotation = deg_to_rad(90)
		octo_dir = MDir.LEFT
	elif ndir == MDir.RIGHT:
		mvec = Vector2(1,0)
		octo_anim.rotation = deg_to_rad(270)
		octo_dir = MDir.RIGHT

func flip_direction():
	#should make the octo go the opposite of whatever direction its going.
	if octo_state == MovementState.MOVING:
		if octo_dir == MDir.LEFT:
			set_direction(MDir.RIGHT)
		else:
			set_direction(MDir.LEFT)

		if octo_dir == MDir.UP:
			set_direction(MDir.DOWN)
			print("flipped to down")
		else:
			set_direction(MDir.UP)
			print("flipped to up")
			
#add idle direction/pointing direction??
func _on_move_timer_timeout():
	next_move()

func _on_top_area_entered(_area):
	if octo_state == MovementState.MOVING:
		set_direction(MDir.DOWN)
	if octo_state == MovementState.HURT:
		hvec.y = 0
		enemy_node.position.y += 2

func _on_bottom_area_entered(_area):
	if octo_state == MovementState.MOVING:
		set_direction(MDir.UP)
	if octo_state == MovementState.HURT:
		hvec.y = 0
		enemy_node.position.y += -2

func _on_left_area_entered(_area):
	if octo_state == MovementState.MOVING:
		set_direction(MDir.RIGHT)
	if octo_state == MovementState.HURT:
		hvec.x = 0
		enemy_node.position.x += 2

func _on_right_area_entered(_area):
	if octo_state == MovementState.MOVING:
		set_direction(MDir.LEFT)
	if octo_state == MovementState.HURT:
		hvec.x = 0
		enemy_node.position.x += -2

func _on_top_body_entered(_body):
	if octo_state == MovementState.MOVING:
		set_direction(MDir.DOWN)
	if octo_state == MovementState.HURT:
		hvec.y = 0
		enemy_node.position.y += 2
	
func _on_bottom_body_entered(_body):
	if octo_state == MovementState.MOVING:
		set_direction(MDir.UP)
	if octo_state == MovementState.HURT:
		hvec.y = 0
		enemy_node.position.y += -2

func _on_left_body_entered(_body):
	if octo_state == MovementState.MOVING:
		set_direction(MDir.RIGHT)
	if octo_state == MovementState.HURT:
		hvec.x = 0
		enemy_node.position.x += 2
	print("left")

func _on_right_body_entered(_body):
	if octo_state == MovementState.MOVING:
		set_direction(MDir.LEFT)
	if octo_state == MovementState.HURT:
		hvec.x = 0
		enemy_node.position.x += -2
	print("right")

func _on_health_hurt():
	print("hurt fired")
	#this signal activates when the health script takes damage.
	octo_state = MovementState.HURT
	var player_pos : Vector2 = player_li.player_ins.global_position
	
	if abs(enemy_node.global_position.x - player_pos.x) < abs(enemy_node.global_position.y - player_pos.y):
		#use y direction
		if enemy_node.global_position.y - player_pos.y < 0:
			hvec = Vector2(0,-1 * kbvel)
			print(hvec)
		else:
			hvec = Vector2(0,1 * kbvel)
			print(hvec)
	else:
		if enemy_node.global_position.x - player_pos.x < 0:
			hvec = Vector2(-1 * kbvel,0)
			print(hvec)
		else:
			hvec = Vector2(1 * kbvel,0)
			print(hvec)

func _on_hurt_timer_timeout():
	#this timer marks the end of the octos reaction to being hurt.
	octo_state = MovementState.MOVING

func _on_hitbox_area_entered(area):
	if area.get_parent() is boomerang:
		#TODO: add some sort of animation for being stunned/coming out of stun state
		octo_state = MovementState.STUN
		stun_timer.start()
