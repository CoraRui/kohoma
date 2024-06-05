extends Node2D


#move the snf


#the snf moves diagonal up and straight down.

@onready var player_li : player_loader = get_node("/root/player_loader_auto")

@export var snf : Node2D

@export var roll_timer : Timer


@export_group("collision")
@export var wall_areas : Array[Area2D]
@export_group("","")

var mvec : Vector2 = Vector2(0,1)
#every other frame
var fdel : int = 0

func _ready():
	#init snf movement direction
	roll_timer.start()
	
func _process(_delta):
	move()
	
func move():
	
	if fdel < 1:
		fdel += 1
		return
	fdel = 0
	snf.position += mvec
	
func roll_change():
	# so, if the player is above snf, theres a higher chance of him going up. otherwise, he'll probably just go down.
	#theres only really three possibilities.
	
	var down : int = 20
	
	if player_li.player_ins.global_position.y > global_position.y:
		down += 20
	
	var left : int = 20
	
	#change probability based on player position
	if player_li.player_ins.global_position.x < global_position.x:
		left += 15
	if player_li.player_ins.global_position.y < global_position.y:
		left += 15
	

		
	
	var right : int = 20
	
	if player_li.player_ins.global_position.x > global_position.x:
		right += 15
	if player_li.player_ins.global_position.y < global_position.y:
		right += 15
	
	#check for collision
	if wall_areas[0].has_overlapping_bodies() || wall_areas[0].has_overlapping_areas():
		left = 0
		right = 0
	if wall_areas[1].has_overlapping_areas() || wall_areas[1].has_overlapping_bodies():
		down = 0
	if wall_areas[2].has_overlapping_bodies() || wall_areas[2].has_overlapping_areas():
		left = 0
	if wall_areas[3].has_overlapping_bodies() || wall_areas[3].has_overlapping_areas():
		right = 0
	
	var total : int = down + left + right
	
	var roll : int = randi_range(0,total)
	
	roll -= down
	if roll <= 0:
		mvec = Vector2(0,1)
		roll += 1000
		
	roll -= left
	if roll <= 0:
		mvec = Vector2(-1,-1)
		roll += 1000
		
	roll -= right
	if roll <= 0:
		mvec = Vector2(1,-1)
		roll += 1000
	roll_timer.start()

func _on_roll_timer_timeout():
	roll_change()

#area collisions. each area represents a side of da dog. if da dog touches da wall,go a different way.

func _on_left_area_area_entered(_area):
	#left wall collided. move right and up.
	mvec = Vector2(1,-1)

func _on_up_area_area_entered(_area):
	#top area collided, move down
	mvec = Vector2(0,1)

func _on_down_area_area_entered(_area):
	if randi_range(0,1) == 0:
		mvec = Vector2(1,-1)
	else:
		mvec = Vector2(-1,-1)
		
func _on_right_area_area_entered(_area):
	mvec = Vector2(-1,-1)

func _on_left_area_body_entered(_body):
		#left wall collided. move right and up.
	mvec = Vector2(1,-1)

func _on_right_area_body_entered(_body):
	mvec = Vector2(-1,-1)

func _on_down_area_body_entered(_body):
	if randi_range(0,1) == 0:
		mvec = Vector2(1,-1)
	else:
		mvec = Vector2(-1,-1)
		
func _on_up_area_body_entered(_body):
	mvec = Vector2(0,1)
