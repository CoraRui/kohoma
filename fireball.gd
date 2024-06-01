extends Node2D


#TODO: add damage
#TODO: deflection??? later

#this should direct the fire towards the player.
#I'll probably just have it be 8 directional. or maybe 16?

@export var fire_anim : AnimatedSprite2D

var u_vec : Vector2 = Vector2(0,0)
var dir_vec : Vector2 = Vector2(1,1)
var frame_vec : Vector2 = Vector2(0,0)

@export var del_timer : Timer

#autoload
@onready var player_li : player_loader = get_node("/root/player_loader_auto")

func _ready():
	find_path()
	del_timer.start()

func _physics_process(_delta):
	move()

func find_path():
	if not player_li.player_ins:
		u_vec = Vector2(1,0)
		return 
	u_vec = player_li.player_ins.global_position - global_position
	u_vec = 2 * u_vec.normalized()
	print(u_vec)
	if u_vec.x < 0:
		u_vec.x *= -1
		dir_vec.x *= -1
	if u_vec.y < 0:
		u_vec.y *= -1
		dir_vec.y *= -1
	
func move():
	if frame_vec.x > u_vec.x:
		frame_vec.x = 0
		position.y += dir_vec.y
	if frame_vec.y > u_vec.y:
		frame_vec.y = 0
		position.x += dir_vec.x
	frame_vec += Vector2(1,1)










