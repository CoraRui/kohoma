extends Node2D
class_name enemy_health

signal hurt
signal death

@export var hp : int = 10

@export var mhp : int = 10

@export var die_node : Node2D

@export var i_frames : int = 17

@export var hurt_timer : Timer

#current i_frame counter
var if_count : int = 0

#invincibility from hit
var inv : bool = false

@export var hurt_sf : String = "e_hurt"

@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")


func _process(_delta):
	if inv:
		inc_inv()
		
func inc_inv():
	if_count += 1
	if if_count >= i_frames:
		if_count = 0
		inv = false

func damage(d : int):
	if inv:
		return
	hp -= d
	print(d, " damage dealt to ", die_node.name)
	hp = clampi(hp, 0, 999)
	inv = true
	if hp == 0:
		die()
	hurt_timer.start()
	hurt.emit()
	sfx_pi.play_sound("e_hurt")

func die():
	death.emit()
	if die_node:
		die_node.queue_free()
	else:
		print("no die node specified for: ", name)
