extends Node2D
class_name world

#ok, gotta make sure i have this straight.
#this script references a world tree in order to grab certain levels from it.
#namely by adjacency. cause im loading in "adjacent" levels
#it may also load levels in different ways later.
#but right now its just adjacent.
#calling draw adjacent will initiate all of the necessary changes to shift the level in the direction passed.

#TODO: disable certain functions on level scroll(inventory, pause, movement, attacking, etc.)

#export categories

#region stage_shift exports

@export_group("stage_shift parameters")
@export var world_draw_offset : Vector2i = Vector2(0,0)		#i think this was originally when the levels had an offset in the transport.
															#so i likely don't need it anymore. but you can remove it later.
@export var shift_speed : int = 3							#
@export var level_size : Vector2i = Vector2i(176, 112)		#total intended size of each stage. not just screen size, considers stat bar.

#internals
var target_pos : Vector2 = Vector2(0,0)
var shifting : bool = false
@export_group("","")


#endregion

#region level_instantiation exports

@export_group("level_instantiaiton")
@export var current_grid : world_tree
#internals
var previous_level : Node2D					#old level. just held here to queue free after camera moves.
var current_level : Node2D					#currently instantiated level
var clp : Vector2i = Vector2i(10,10)		#current position in level tree

@export_group("","")

#endregion

#export auto/signals

#region autoloads

@onready var camera_li : camera_loader = get_node("/root/camera_loader_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var level_bi : level_border = get_node("/root/level_border_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")

#endregion

#region signals

signal world_snapped			#signal to be emitted when the world is finished shifting

#endregion

#functions

#region runtime functions

func _physics_process(_delta):
	shift_level()

#endregion

#region level_shift functions

func shift_level():
	if not shifting:
		return
	previous_level.global_position = previous_level.global_position.move_toward(target_pos, shift_speed)
	current_level.global_position = current_level.global_position.move_toward(target_pos, shift_speed)
	player_li.player_ins.global_position += shift_speed * current_level.global_position.direction_to(target_pos)
	
	if previous_level.global_position == target_pos:
		level_bi.toggle_border(true)
		shifting = false
		target_pos = Vector2(0,0)
		previous_level.queue_free()
		current_level.global_position = Vector2(0,0)
		player_li.player_ins.set_movement(true)

func init_level_shift(dp : Vector2) -> void:
	#should set all necessary variables to start a level shift.
	#used mostly in the draw_level_adj function.
	#dp is the delta position. indicates direction to shift level.
	shifting = true										#sets shifting marker to true, physics_process will now start shifting the levels.
	target_pos = Vector2(-176, -112) * Vector2(dp)		#sets the target point for the previous level to move to.

#endregion

#region level_loading functions

func draw_level_at(lp : Vector2i) -> void:
	#instantiates the level at lp in the current world tree and resets everything to zero
	clp = lp
	if current_level:
		current_level.queue_free()
	current_level = current_grid.get_level_at(lp).level_node.instantiate()
	get_tree().get_root().add_child.call_deferred(current_level)
	player_li.unload_player_fast()
	#make sure that theres a spawn point in the level where the player is being loaded
	player_li.load_player()
	level_bi.reset_position()
	stat_bi.reset_position()
	
func draw_level_adj(dp : Vector2i) -> void:
	#this function takes a vector parameter, dp (delta_position). should be a cardinal directions unit vector.
	#it draws the level at the proper position, above, below, or beside the currently loaded level.
	#it then moves both levels over so that the new level will be the new focus.
	#then it clears the last level, and proceeds normally.
	
	
	clp += dp							#shift current position
	previous_level = current_level		#set the current level as the old one
	current_level = current_grid.get_level_at(clp).level_node.instantiate()		#instantiate the new level, add it to current
	get_tree().get_root().add_child.call_deferred(current_level)				#add new level to tree
	current_level.global_position = level_size * dp								#sets the position of the new level in the proper direction(udlr)

func clear_previous_level() -> void:
	#function used to clear the previous level.
	#cause I have to wait until after the camera moves. 
	if previous_level:
		previous_level.queue_free()

func unload_level() -> void:
	#TODO: not sure i need unload_level(). i don't really have need for it in an external function.
	current_level.queue_free()
	current_level = null

#endregion


#region tree_management functions

func switch_to_tree(nt : String, ip : Vector2, psi : int) -> void:
	remove_child(current_grid)
	current_grid = load(nt).instantiate()
	add_child(current_grid)
	draw_level_at(ip)
	camera_li.reset_camera()
	for c in current_level.get_children():
		if c is load_info:
			player_li.player_ins.global_position = c.player_spawn[psi].global_position

#endregion
