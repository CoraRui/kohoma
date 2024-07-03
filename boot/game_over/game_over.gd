extends Node2D

#controls processes related to the game over screen.

#so what do i even need to happen?
#and besides the actual game over screen, what else do i want to happen on death?
#i do want that stop pause where everything disappears except for the player and the attacker.
#then maybe a little player animation at the point they were killed.
#could drag the player sprite to a certain position on the screen, then display some text and restart

#what phases will there be in the stop pause which are simply controlled by length?

#first phase: stop pause
#so once the player is fatally damaged, a couple things will happen immediately and simultaneously:
#current level/ any other things that need to be are freed except the player and the source of damage
#music stops
#some sort of death hurt sound effect
#then a short delay until the next phase.

#second phase: transition into game over
#some sort of player animation, another sound effect.

#third phase: game over
#game over screen appears
#game over music plays
#death text starts to play
#allow for input to advance through that text

#so how am i doing states?
#could just have an integer i guess lol.

#TODO: background? probably just a black color rect but it might be more

@export_group("stop_pause parameters")
@export var sp_phase : int = 0			#(1: stop pause, 2 : transition, 3: game over)
@export var sp_timer : Timer 			#timer used for stop pause phases
@export var sp_length : float = 1.5 	#length of the first phase of the stop pause(sp)
@export var tr_length : float = 1.5		#length of the transitionary phase between stop pause and game over screen
@export_group("","")

@export_group("game over parameters")
@export var game_over_mlink : music_link	#music to be played on game over phase
@export var game_init_ins : game_init
@export_group("","")

#region autoloads

@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var world_i : world = get_node("/root/world_auto")
@onready var pause_li : pause_loader = get_node("/root/pause_loader_auto")
@onready var curtain_mi : curtain_module = get_node("/root/curtain_module_auto")
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")

#endregion

func _ready():
	stop_pause()
	sp_phase += 1
	sp_timer.wait_time = sp_length
	sp_timer.start()
	
	player_li.player_ins.set_items_active(false)
	player_li.player_ins.set_movement(false)
	player_li.player_ins.set_sword_active(false)
	world_i.unload_level()
	
	pause_li.toggle_active(false)

func _input(event):
	if event.is_action_pressed("start") && sp_phase >=2:
		end_game_over()

func end_game_over():
	#function to run once the game over scene is finished
	debug_helper.db_message("ran end game over","game over")
	player_li.unload_player()
	game_init_ins.load_world(save_fi.file_index)
	
	#curtain close and load delay, then load the world back in.
	

#region stop pause phase triggers

func stop_pause() -> void:
	#first phase
	debug_helper.db_message("stop pause phase","game over")
	
	stat_bi.toggle_bar(false)
	player_li.player_ins.set_items_active(false)
	player_li.player_ins.set_movement(false)
	player_li.player_ins.set_sword_active(false)

func to_game_over() -> void:
	#transitionary phase
	debug_helper.db_message("to game over phase","game over")

func game_over() -> void:
	#game over screen plays
	#calls loading functino in death_trigger to avoid load in/out confusion
	debug_helper.db_message("game over phase","game over")
	music_pi.play_music_link(game_over_mlink)
	
	

#endregion

func _on_stop_pause_timer_timeout():
	match sp_phase:
		1:
			to_game_over()
			sp_phase += 1
			sp_timer.wait_time = tr_length
			sp_timer.start()
		2:
			game_over()
			sp_phase += 1
			#no timer needed, no further phases
		_:
			print("stop pause timer ran an extra time in game over")









