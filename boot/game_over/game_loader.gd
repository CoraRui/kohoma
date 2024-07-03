extends Node2D
class_name game_loader

#ok im having trouble deciding what to put in here, and what to put into the game over scene itself.
#the reason i wanted an autoload for this was to have something that would be unaffected by the changing
#states. like unloading the world, loading in a new thing, etc.
#following that logic, the only functions i want to have in here are ones that
#are pursuant of that. so when the player dies, call the game over function to instantiate the game over scene
#once the game over screen is finished, load wherever. probably using the game init script?
#also i need to be more conscious of what actually is happening during game init.

#i think i should move the functionality of game init here.
#so im moving the functionality of game init here to make loading things in less of a hassle by having a permanent object.
#but...
#i still need a spot to store parameters for the load.
#so where? 
#one: create some sort of trigger to deal with it that you can instantiate in places you need to interact with the death trigger from.
#two: create a resource to hold all of the values you need to pass in, then write all of those values in code(this would suck)
#three: pass in by dictionary(would also suck)
#I think the trigger option is best. but then how am i passing in paramters? how exactly should the load game thing work.

@export var game_over_ref : PackedScene
@export var game_over_mus : String

#region autoloads

@onready var world_i : world = get_node("/root/world_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var camera_i : camera_loader = get_node("/root/camera_loader_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var level_bi : level_border = get_node("/root/level_border_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var pause_li : pause_loader = get_node("/root/pause_loader_auto")

#endregion

func game_over():
	var game_over_ins : Node2D = game_over_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(game_over_ins)

func load_game(fi : int, l : PackedScene, lp : Vector2):
	#this function loads the game as if it were loaded from the file select screen. which usually it literally will be.
	#fi is the index of the file to be loaded.
	#l is the packed scene of the room to be loaded, if there is one
	#lp is the level position of the level to be loaded if there is one.
	#only uses the world loader if theres no l
	
	if !l:
		world_i.draw_level_at(lp)
	else:
		var new_room = l.instantiate()
		get_tree().get_root().add_child(new_room)
		new_room.global_position += Vector2(0,-32)
	save_fi.load_file(fi)
	player_li.load_player()
	stat_bi.set_visible(true)
	pause_li.toggle_active(true)
	
