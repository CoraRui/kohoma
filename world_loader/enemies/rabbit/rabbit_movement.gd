extends Node2D


#TODO: add health and knockback behavior

@export_group("node exports")
@export var rab_body : Node2D
@export var h_timer : Timer 	#timer for delay between direction changes
@export var rabbit_anim : AnimatedSprite2D
@export_group("","")

#time between horizontal direction changes
@export var h_del : float = 0.8

@export_group("collision")
@export var side_area : Area2D
@export var vert_area : Area2D
@export var col_pts : Array[Node2D]
@export_group("","")

var mvec = Vector2(1,1)
var f_skip : int = 0
var skip : int = 2

func _ready():
	h_timer.wait_time = h_del
	h_timer.start()
	if mvec.y == -1:
		vert_area.global_position = col_pts[0].global_position
	if mvec.y == 1:
		vert_area.global_position = col_pts[1].global_position

func _physics_process(_delta):
	move()

func change_move():
	#so here, every time the timer fires, the rabbit switches horizontal direction.
	#it also randomizes the timer for the next movement.
	mvec.x *= -1
	#reset the timer
	h_timer.wait_time = h_del
	h_timer.start()

func move():
	if f_skip < skip:
		f_skip += 1
		return
	else:
		rab_body.position += mvec
		f_skip = 0

func _on_h_timer_timeout():
	change_move()

func switch_y():
	mvec.y *= -1

func _on_rdown_area_area_entered(_area):
	print(rab_body.global_position)
	#vertical area collision, change y direction
	mvec.y *= -1
	if mvec.y == 1:
		vert_area.global_position = col_pts[1].global_position
	else:
		vert_area.global_position = col_pts[0].global_position

func _on_rdown_area_body_entered(_body):
	#vertical area collision, change y direction
	mvec.y *= -1
	if mvec.y == 1:
		vert_area.global_position = col_pts[1].global_position
	else:
		vert_area.global_position = col_pts[0].global_position
