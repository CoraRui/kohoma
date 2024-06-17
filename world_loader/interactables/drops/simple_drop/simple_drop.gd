extends Node2D

#this script just contains a reference to a packed scene which it will instantiate when its function is called.

#TODO: random 
#TODO: use player information to decide what kind of object is dropped/effect drop rates etc. most obviously, no hearts when full health,
#TODO: maybe more rupees when high health, raise fairy rates and heart rates when low. etc etc.


@export var drop_thing : PackedScene

@export var drop_sn : sf_link

#node to attach dropped object to
@export var inh_target : Node2D

#node to use position of for dropped object
@export var pos_target : Node2D

#autoloads
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")


func drop():
	
	var new_thing : Node2D = drop_thing.instantiate()
	if inh_target:
		inh_target.add_child(new_thing)
	else:
		get_tree().get_root().add_child(new_thing)
	if pos_target:
		new_thing.global_position = pos_target.global_position
	
func _on_health_death():
	drop()

func _on_push_block_block_clicked():
	drop()

func _on_enemy_health_death():
	drop()
