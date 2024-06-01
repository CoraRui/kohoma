extends Node2D
class_name player_loader

#autoload for loading the player in and out of the scene.

@export var player_ref : PackedScene

var player_ins : player

func load_player():
	if player_ins:
		print("attempted to make second player")
		return
	player_ins = player_ref.instantiate()
	add_child.call_deferred(player_ins)
	player_ins.global_position = Vector2(128,88)
	
func unload_player():
	if player_ins:
		player_ins.queue_free()
	else:
		print("player loader attempted to unload null player")

func unload_player_fast():
	if not player_ins:
		print("no player to quickly unload")
		return
	remove_child(player_ins)
	player_ins.free()
	player_ins = null
