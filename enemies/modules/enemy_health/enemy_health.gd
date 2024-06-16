extends Node2D
class_name enemy_health

#the enemy health script generally works by just waiting to be contacted by the sword script.
#the sword script checks for areas when swung and looks for nodes of type enemy_health.
#the area should be placed as a sibling of the health script, on the enemy layer.


#region export groups
@export_group("stats")
@export var hp : int = 10
@export var mhp : int = 10
@export_group("","")

@export_group("invincibility")
@export var i_frames : int = 17
var if_count : int = 0
var inv : bool = false
@export_group("","")

@export_group("hurt")
signal hurt
@export var hurt_sf : String = "e_hurt"
@export_group("","")

#region death
@export_group("death")
signal death
@export var die_node : Node2D
@export var use_death_delay : bool = false
@export var death_delay : float = 0.5
@export var death_timer : Timer
@export var use_effect : bool = false
@export var death_effect : PackedScene
@export_group("","")
#endregion

#endregion

#autoloads
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var world_i : world = get_node("/root/world_auto")

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
	#check for invincibility
	if inv:
		return
	inv = true
	sfx_pi.play_sound("e_hurt")
	hurt.emit()
	#deal damage/check for death
	hp -= d
	hp = clampi(hp, 0, 999)
	if hp == 0:
		die()
	
func die():
	death.emit()
	#instantiate a death effect if there is one.
	if use_effect && death_effect:
		var new_effect : Node2D = death_effect.instantiate()
		world_i.current_level.add_child(new_effect)
		new_effect.global_position = global_position
	
	#free the main node if there is one. (usually there should be)
	if die_node:
		die_node.queue_free()
	else:
		print("no die node specified for: ", name)
