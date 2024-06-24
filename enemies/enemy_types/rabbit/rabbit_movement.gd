extends Node2D


enum RabbitState { MOVE, HURT, DYING}
var rabbit_state : RabbitState = RabbitState.MOVE

#region exports
@export_group("node exports")
@export var rab_body : Node2D
@export var h_timer : Timer 			#timer for delay between direction changes
@export var rabbit_anim : AnimatedSprite2D
@export_group("","")

#time between horizontal direction changes
@export var h_del : float = 0.8

@export_group("collision")
@export var side_area : Area2D
@export var vert_area : Area2D
@export var col_pts : Array[Node2D]		#holds points for collision area relocation. udlr indexes.
@export_group("","")

#endregion

#region movement state variables

#MOVE
var mvec : Array[Vector2] = [Vector2(1,1), Vector2(0,0)]
var mindex : int = 0

#HURT
var hvec : Array[Vector2] = [Vector2(0,0), Vector2(0,0)]
var hindex : int = 0

#endregion

func _ready():
	h_timer.wait_time = h_del
	h_timer.start()
	if mvec[0].y == -1:
		vert_area.global_position = col_pts[0].global_position
	if mvec[0].y == 1:
		vert_area.global_position = col_pts[1].global_position

func _physics_process(_delta):
	select_move_state()

func select_move_state():
	#chooses the movement type based on the state
	match rabbit_state:
		RabbitState.MOVE:
			move()

func change_move():
	#so here, every time the timer fires, the rabbit switches horizontal direction.
	#it also randomizes the timer for the next movement.
	mvec[0].x *= -1
	#reset the timer
	h_timer.wait_time = h_del
	h_timer.start()

func move():
	rab_body.global_position += mvec[mindex]
	mindex += 1
	if mindex >= mvec.size():
		mindex = 0

func _on_h_timer_timeout():
	change_move()

func switch_y():
	#switches the y direction. use during wall collision
	mvec[0].y *= -1
	match mvec[0].y:
		1:
			vert_area.global_position = col_pts[1].global_position
		-1:
			vert_area.global_position = col_pts[0].global_position

func switch_x():
	#flips x direction. use during wall collision and timed movement
	mvec[0].y *= -1
	match mvec[0].y:
		1:
			vert_area.global_position = col_pts[3].global_position
		-1:
			vert_area.global_position = col_pts[2].global_position

func _on_rdown_area_area_entered(_area):
	match rabbit_state:
		RabbitState.MOVE:
			switch_y()

func _on_rdown_area_body_entered(_body):
	match rabbit_state:
		RabbitState.MOVE:
			switch_y()

func _on_rside_area_area_entered(area):
	match rabbit_state:
		RabbitState.MOVE:
			switch_x()
		RabbitState.HURT:
			pass

func _on_rside_area_body_entered(body):
	switch_x()
