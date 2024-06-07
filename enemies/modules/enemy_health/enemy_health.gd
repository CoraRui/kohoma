extends Node2D
class_name enemy_health


#node to be deleted on enemu death


#region export groups
@export_group("stats")
@export var hp : int = 10
@export var mhp : int = 10
@export_group("","")

@export_group("invincibility")
#TODO: 
@export var i_frames : int = 17
var if_count : int = 0
var inv : bool = false
@export_group("","")

@export_group("hurt")
signal hurt
@export var hurt_sf : String = "e_hurt"
@export_group("","")

@export_group("death")
signal death
@export var die_node : Node2D
@export var use_death_delay : bool = false
@export var death_delay : float = 0.5
@export var death_timer : Timer
@export_group("","")

#endregion

#autoloads
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

func _process(_delta):
	inc_inv()
		
func inc_inv():
	if not inv:
		return
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
	hurt.emit()
	sfx_pi.play_sound("e_hurt")

func die():
	death.emit()
	
	if die_node:
		die_node.queue_free()
	else:
		print("no die node specified for: ", name)
