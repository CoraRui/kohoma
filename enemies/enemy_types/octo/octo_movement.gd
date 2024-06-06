extends Node2D
class_name octo_movement

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
#TODO: fix boingboingboing
#TODO: do I want the octo to be able to turn without stopping? might be kind of annoying/too random.
#TODO: also consider using a more basic movement pattern. I feel like its getting too complex.
#TODO: have a few different presets of movement for use in specific area types?

#ok. so the most basic idea of the script is that theres an mvec that is used to change the position of the octo once per frame.
#I'm probably going to use a similar principle for other movement scripts. But point is, that's not too much to reproduce.

#each enemy should have unique states since the states that they have will ultimately be unique since they move in different ways.
enum OctoState {MOVING, HURT, KO, STUN}

#being replaced with dir class
#enum MDir {UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3}

var octo_state : OctoState = OctoState.MOVING

var octo_dir : DirClass.Dir = DirClass.Dir.DOWN

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

@export_group("collision areas")
@export var top_area : Area2D
@export var bottom_area : Area2D
@export var left_area : Area2D
@export var right_area : Area2D
@export var bump_timer : Timer
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
		set_direction(DirClass.Dir.UP)
		r += 1000
	r -= down
	if r < 0:
		set_direction(DirClass.Dir.DOWN)
		r+= 1000
	r -= left
	if r < 0:
		set_direction(DirClass.Dir.LEFT)
		r += 1000
	r -= right
	if r < 0:
		set_direction(DirClass.Dir.RIGHT)
		r += 1000
		
	move_timer.start()

func move_timer_reset():
	#resets the movement timer. mostly for if a wall collision takes place so there isn't jerky movement
	move_timer.stop()
	move_timer.start()

func move():
	if octo_state == OctoState.MOVING:
		enemy_node.global_position += mvec
		if mvec.x != 0 && mvec.y != 0:
			print(mvec)
	elif octo_state == OctoState.HURT:
		enemy_node.global_position += hvec
	elif octo_state == OctoState.STUN:
		#TODO: possibly add some sort of stunned movement pattern? but they can just be still for now.
		pass

func set_direction(ndir : DirClass.Dir):
	#account for hurt direction?
	if ndir == DirClass.Dir.UP:
		mvec = Vector2(0,-1)
		octo_anim.rotation = deg_to_rad(180)
		octo_dir = DirClass.Dir.UP
	elif ndir == DirClass.Dir.DOWN:
		mvec = Vector2(0,1)
		octo_anim.rotation = deg_to_rad(0)
		octo_dir = DirClass.Dir.DOWN
	elif ndir == DirClass.Dir.LEFT:
		mvec = Vector2(-1,0)
		octo_anim.rotation = deg_to_rad(90)
		octo_dir = DirClass.Dir.LEFT
	elif ndir == DirClass.Dir.RIGHT:
		mvec = Vector2(1,0)
		octo_anim.rotation = deg_to_rad(270)
		octo_dir = DirClass.Dir.RIGHT

func flip_direction():
	#should make the octo go the opposite of whatever direction its going.
	#TODO: the octo tends to get stuck in single tile gaps cause its response to hitting a wall is to just turn around and then it just vibrates.
	#TODO: to fix that, I think I'll do like a short pause before the next movement, as well as try to make it impossible to turn in a direction thats "blocked"
	
	if octo_state == OctoState.MOVING:
		if octo_dir == DirClass.Dir.LEFT:
			set_direction(DirClass.Dir.RIGHT)
		else:
			set_direction(DirClass.Dir.LEFT)

		if octo_dir == DirClass.Dir.UP:
			set_direction(DirClass.Dir.DOWN)
			print("flipped to down")
		else:
			set_direction(DirClass.Dir.UP)
			print("flipped to up")

#add idle direction/pointing direction??
func _on_move_timer_timeout():
	next_move()

#most of these triggers will incur specific changes in the creatures behavior dependent on their current movement state.
func _on_top_area_entered(_area):
	if octo_state == OctoState.MOVING:
		#if they're going up, there should be a brief pause, then they should turn around.
		#unless theres a wall behind them ,in which case they should go either left or right.
		if bottom_area.has_overlapping_bodies():
			if randi_range(0,1):
				set_direction(DirClass.Dir.LEFT)
			else:
				set_direction(DirClass.Dir.RIGHT)
		else:
			set_direction(DirClass.Dir.DOWN)
	if octo_state == OctoState.HURT:
		hvec.y = 0
		enemy_node.position.y += 2

func _on_bottom_area_entered(_area):
	if octo_state == OctoState.MOVING:
		if top_area.has_overlapping_bodies():
			if randi_range(0,1):
				set_direction(DirClass.Dir.LEFT)
			else:
				set_direction(DirClass.Dir.RIGHT)
		else:
			set_direction(DirClass.Dir.UP)
	if octo_state == OctoState.HURT:
		hvec.y = 0
		enemy_node.position.y += -2

func _on_left_area_entered(_area):
	if octo_state == OctoState.MOVING:
		if bottom_area.has_overlapping_bodies():
			if randi_range(0,1):
				set_direction(DirClass.Dir.UP)
			else:
				set_direction(DirClass.Dir.DOWN)
		else:
			set_direction(DirClass.Dir.RIGHT)
	if octo_state == OctoState.HURT:
		hvec.x = 0
		enemy_node.position.x += 2

func _on_right_area_entered(_area):
	if octo_state == OctoState.MOVING:
		if bottom_area.has_overlapping_bodies():
			if randi_range(0,1):
				set_direction(DirClass.Dir.DOWN)
			else:
				set_direction(DirClass.Dir.UP)
		else:
			set_direction(DirClass.Dir.LEFT)
	if octo_state == OctoState.HURT:
		hvec.x = 0
		enemy_node.position.x += -2

func _on_top_body_entered(_body):
	if octo_state == OctoState.MOVING:
		#if they're going up, there should be a brief pause, then they should turn around.
		#unless theres a wall behind them ,in which case they should go either left or right.
		if bottom_area.has_overlapping_bodies():
			if randi_range(0,1):
				set_direction(DirClass.Dir.LEFT)
			else:
				set_direction(DirClass.Dir.RIGHT)
		else:
			set_direction(DirClass.Dir.DOWN)
	if octo_state == OctoState.HURT:
		hvec.y = 0
		enemy_node.position.y += 2

func _on_bottom_body_entered(_body):
	if octo_state == OctoState.MOVING:
		if top_area.has_overlapping_bodies():
			if randi_range(0,1):
				set_direction(DirClass.Dir.LEFT)
			else:
				set_direction(DirClass.Dir.RIGHT)
		else:
			set_direction(DirClass.Dir.UP)
	if octo_state == OctoState.HURT:
		hvec.y = 0
		enemy_node.position.y += -2

func _on_left_body_entered(_body):
	if octo_state == OctoState.MOVING:
		if bottom_area.has_overlapping_bodies():
			if randi_range(0,1):
				set_direction(DirClass.Dir.UP)
			else:
				set_direction(DirClass.Dir.DOWN)
		else:
			set_direction(DirClass.Dir.RIGHT)
	if octo_state == OctoState.HURT:
		hvec.x = 0
		enemy_node.position.x += 2
	print("left")

func _on_right_body_entered(_body):
	if octo_state == OctoState.MOVING:
		if bottom_area.has_overlapping_bodies():
			if randi_range(0,1):
				set_direction(DirClass.Dir.UP)
			else:
				set_direction(DirClass.Dir.DOWN)
		else:
			set_direction(DirClass.Dir.LEFT)
	if octo_state == OctoState.HURT:
		hvec.x = 0
		enemy_node.position.x += -2
	print("right")

func _on_health_hurt():
	print("hurt fired")
	#this signal activates when the health script takes damage.
	octo_state = OctoState.HURT
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
	octo_state = OctoState.MOVING

func _on_hitbox_area_entered(area):
	if area.get_parent() is boomerang:
		#TODO: add some sort of animation for being stunned/coming out of stun state
		octo_state = OctoState.STUN
		stun_timer.start()
