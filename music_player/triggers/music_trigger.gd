extends Node2D


#need a way to make sure the trigger doesn't activate again if its not meant to.
#I can:
#queue the whole thing free after play
#have some variable that indicates that the track has already been played.

#region track_info

@export_group("track info")
#plays if true, stops if false.
@export var playstop : bool = true
#name of track to be played
@export var track_name : String = "test_track"
#volume to play track with
@export var track_vol : float = 1.0
@export_group("","")

#endregion

#region trigger info

@export_group("trigger info")
@export var use_ready : bool = true			#starts track when this node is added to tree if true
@export var use_delay : bool = false		#waits for a certain delay to start the track if true
@export var track_timer : Timer				#timer used to wait for delay
@export var delay_duration : float = 1		#duration to wait for use_delay
@export var on_collision : bool = false		#uses the areas entered signal to trigger the track
@export var track_coll : Area2D				#area used to trigger track play on enter
@export var free_after_play : bool = false	#if true, frees the music trigger once the song has been triggered.
@export var free_node : Node2D				#the node to be deleted on free
@export_group("","")

#endregion

#autoload
@onready var music_pi : music_player = get_node("/root/music_player_auto")

func _ready():
	
	if use_ready:
		if not use_delay:
			trigger_music()
		else:
			track_timer.start()
	
	if not on_collision:
		track_coll.queue_free()

func trigger_music() -> void :
	if playstop:
		music_pi.play_track(track_name)
	else:
		music_pi.stop_track()
	
	#frees the node after the music is triggered if desired.
	if free_after_play:
		if free_node:		#check if there is a free node indicated. free this node if not.
			free_node.queue_free()
		else:
			queue_free()
	
func _on_track_collider_body_entered(_body):
	if on_collision:
		trigger_music()

func _on_track_timer_timeout():
	if use_delay:
		trigger_music()
