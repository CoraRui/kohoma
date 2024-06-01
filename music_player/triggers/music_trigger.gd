extends Node2D


#this script should trigger a certain track to play.


@export_group("track info")
#plays if true, stops if false.
@export var playstop : bool = true
#name of track to be played
@export var track_name : String = "test_track"
#volume to play track with
@export var track_vol : float = 1.0
@export_group("","")

@export_group("trigger info")
#triggers the track as soon as this trigger loads
@export var use_ready : bool = true
#triggers the track after a delay in ready
@export var use_delay : bool = false
#triggers the track when something triggers the area2D
@export var on_collision : bool = false
#timer used for delayed playing
@export var track_timer : Timer
#area2d used for collision triggering
@export var track_coll : Area2D
@export_group("","")


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
			
func trigger_music():
	if playstop:
		music_pi.play_track(track_name)
	else:
		music_pi.stop_track()
	
func _on_track_collider_body_entered(_body):
	trigger_music()

func _on_track_timer_timeout():
	trigger_music()
