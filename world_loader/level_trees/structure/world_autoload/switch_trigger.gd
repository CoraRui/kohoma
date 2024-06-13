extends Node2D
#this script should trigger the tree_switch trigger in the world
#the actual signal comes from something added. theres no inherent trigger area in the node itself
#I wanna add a transition scene, or maybe a couple possible transition settings.
#how should it look?
#in terms of the actual screen darkening, either a short delay then immediate to black, or a delay then an incremental darkening
#for the player, a walking into the door thing would be cool. but screen first.


@export_file var new_tree : String = "res://world_loader/level_trees/game_trees/"
#initial position in the new level tree.
@export var init_pos : Vector2
#spawn index for player in initial room
@export var psi : int


#autoloads
@onready var world_i : world = get_node("/root/world_auto")

var fuck_you : bool = false

func switch_tree():
	if fuck_you:
		return
	else:
		fuck_you = true
	world_i.switch_to_tree(new_tree, init_pos, psi)

#for some reason switch trigger activates twice.
#i don't know WHY. but it does. 
#the fuck you variable just disables that second run for now.
func _on_switch_area_area_entered(_area):
	switch_tree()


