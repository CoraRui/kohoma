extends Node2D
class_name world

#this node is the autoload world.
#it contains a node , which contains a world tree.
#that world tree contains a series of children with children, which contain a level in each node.
#this creates a 2D array like structure of levels, which the world autoload can reference.

@export var current_grid : world_tree

#current level position in the level tree
var clp : Vector2i = Vector2i(10,10)

#transform position of level load
@onready var tlp : Vector2i = clp

#old level. just held here to queue free after camera moves.
var previous_level : Node2D

#currently instantiated level
var current_level : Node2D

@export var level_size : Vector2i = Vector2i(176, 112)

#autoloads
@onready var camera_li : camera_loader = get_node("/root/camera_loader_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var level_bi : level_border = get_node("/root/level_border_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")

func draw_level_at(lp : Vector2i):
	#instantiates the level at lp in the current world tree and resets everything to zero
	print("twice?")
	clp = lp
	if current_level:
		current_level.queue_free()
	current_level = current_grid.get_level_at(lp).level_node.instantiate()
	get_tree().get_root().add_child.call_deferred(current_level)
	camera_li.reset_camera()
	player_li.unload_player_fast()
	#make sure that theres a spawn point in the level where the player is being loaded
	player_li.load_player()
	level_bi.reset_position()
	stat_bi.reset_position()
	reset_position()
	
func draw_level_adj(dp : Vector2i):
	#draws the level at the position clp + dp in the current world tree.
	clp += dp
	tlp += dp
	previous_level = current_level
	current_level = current_grid.get_level_at(clp).level_node.instantiate()
	get_tree().get_root().add_child.call_deferred(current_level)
	current_level.global_position = tlp * level_size

func clear_previous_level():
	#function used to clear the previous level.
	#cause I have to wait until after the camera moves. 
	if previous_level:
		previous_level.queue_free()
	
func unload_level():
	current_level.queue_free()
	current_level = null

func switch_to_tree(nt : String, ip : Vector2, psi : int):
	remove_child(current_grid)
	current_grid = load(nt).instantiate()
	add_child(current_grid)
	draw_level_at(ip)
	camera_li.reset_camera()
	for c in current_level.get_children():
		if c is load_info:
			player_li.player_ins.global_position = c.player_spawn[psi].global_position
	
func reset_position():
	tlp = Vector2i(0,0)
	
	
