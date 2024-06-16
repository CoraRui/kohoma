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
#TODO: wiggle at more randomized intervals

#ok. so the most basic idea of the script is that theres an mvec that is used to change the position of the octo once per frame.
#I'm probably going to use a similar principle for other movement scripts. But point is, that's not too much to reproduce.

#each enemy should have unique states since the states that they have will ultimately be unique since they move in different ways.
enum OctoState {MOVING, WIGGLE, HURT, KO, STUN}

var octo_state : OctoState = OctoState.MOVING

var octo_dir : DirClass.Dir = DirClass.Dir.DOWN

@export var enemy_node : Node2D

#region export groups
@export_group("hurt")
@export var hurt_timer : Timer
@export var hurt_dur : float = 0.4
@export var kbvel : int
@export_group("","")

@export_group("stun")
@export var stun_timer : Timer
@export_group("","")

@export_group("moving")
@export var move_timer : Timer				#time between movement direction changes
@export var mvec : Array[Vector2] = [Vector2(0,0), Vector2(0,0)]
var mveci : int = 0
@export_group("","")

@export_group("wiggle")
@export var wiggle_timer : Timer
@export var wiggle_anim : String = "wiggle"
@export var wiggle_dur : float = 1.0
@export var wiggle_frames : int = 15			#number of frames between each wiggle flip
var wiggle_index : int = 0
@export_group("","")

@export_group("animation")
@export var octo_anim : AnimatedSprite2D
@export_group("","")

@export_group("wall_collision")
@export var top_area : Area2D
@export var bottom_area : Area2D
@export var left_area : Area2D
@export var right_area : Area2D
@export var bump_timer : Timer
@export_group("","")
#endregion


#autoloads
@onready var player_li : player_loader = get_node("/root/player_loader_auto")

#internals

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
	wiggle_timer.start()
	set_octo_state(OctoState.MOVING)

func move():
	match octo_state:
		OctoState.MOVING:
			enemy_node.global_position += mvec[mveci]
			mveci += 1
			if mveci <= mvec.size():
				mveci = 0
		OctoState.HURT:
			enemy_node.global_position += hvec
		OctoState.STUN:
			#TODO: possibly add some sort of stunned movement pattern? but they can just be still for now.
			pass
		OctoState.WIGGLE:
			wiggle_index += 1
			if wiggle_index >= wiggle_frames:
				wiggle_index = 0
				set_direction(DirClass.get_flip(octo_dir))
			
func set_direction(ndir : DirClass.Dir):
	#account for hurt direction?
	if ndir == DirClass.Dir.UP:
		mvec[0] = Vector2(0,-1)
		octo_anim.rotation = deg_to_rad(180)
		octo_dir = DirClass.Dir.UP
	elif ndir == DirClass.Dir.DOWN:
		mvec[0] = Vector2(0,1)
		octo_anim.rotation = deg_to_rad(0)
		octo_dir = DirClass.Dir.DOWN
	elif ndir == DirClass.Dir.LEFT:
		mvec[0] = Vector2(-1,0)
		octo_anim.rotation = deg_to_rad(90)
		octo_dir = DirClass.Dir.LEFT
	elif ndir == DirClass.Dir.RIGHT:
		mvec[0] = Vector2(1,0)
		octo_anim.rotation = deg_to_rad(270)
		octo_dir = DirClass.Dir.RIGHT

func set_octo_state(s : OctoState):
	match s:
		OctoState.MOVING:
			octo_state = OctoState.MOVING
			move_timer.start()
		OctoState.WIGGLE:
			octo_state = OctoState.WIGGLE
			wiggle_timer.wait_time = wiggle_dur
			wiggle_timer.start()
		OctoState.HURT:
			octo_state = OctoState.HURT
			wiggle_timer.stop()
			
func move_timer_reset():
	#resets the movement timer. mostly for if a wall collision takes place so there isn't jerky movement
	move_timer.stop()
	move_timer.start()

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
		else:
			set_direction(DirClass.Dir.UP)

#add idle direction/pointing direction??
func _on_move_timer_timeout():
	set_octo_state(OctoState.WIGGLE)
	wiggle_timer.start()

#most of these triggers will incur specific changes in the creatures behavior dependent on their current movement state.
#region area triggers
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

#endregion

func _on_health_hurt():
	#this signal activates when the health script takes damage.
	set_octo_state(OctoState.HURT)
	var player_pos : Vector2 = player_li.player_ins.global_position
	if abs(enemy_node.global_position.x - player_pos.x) < abs(enemy_node.global_position.y - player_pos.y):
		#use y direction
		if enemy_node.global_position.y - player_pos.y < 0:
			hvec = Vector2(0,-1 * kbvel)
		else:
			hvec = Vector2(0,1 * kbvel)
	else:
		if enemy_node.global_position.x - player_pos.x < 0:
			hvec = Vector2(-1 * kbvel,0)
		else:
			hvec = Vector2(1 * kbvel,0)
	wiggle_timer.stop()
	hurt_timer.wait_time = hurt_dur
	hurt_timer.start()
	
func _on_hitbox_area_entered(area):
	if area.get_parent() is boomerang:
		#TODO: add some sort of animation for being stunned/coming out of stun state
		octo_state = OctoState.STUN
		stun_timer.start()

func _on_hurt_timer_timeout():
	set_octo_state(OctoState.WIGGLE)
	wiggle_timer.start()

func _on_wiggle_timer_timeout():
	next_move()
	move_timer.start()
