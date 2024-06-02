extends Node2D
class_name boomerang_launcher

#this script just instantiates the boomerang.

#TODO: one throw at a time

enum Thrown {HELD, THROWING, FLYING, DISABLED}

var thrown_state : Thrown = Thrown.HELD

@export var boomerang_ref : PackedScene

@onready var player_i : player_loader = get_node("/root/player_loader_auto")

func throw_boomerang():
	var boom_ins : Node2D = boomerang_ref.instantiate()
	get_tree().get_root().add_child(boom_ins)
	boom_ins.global_position = player_i.player_ins.global_position
	thrown_state = Thrown.THROWING
