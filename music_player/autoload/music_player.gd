extends Node2D
class_name music_player

#this autoload plays music. should be activated by a trigger node.
#for the most part those trigger nodes will be put in certain levels and rooms, and simply play on ready.
#for exact timing though, I can just use timers to delay the start of the music, or link the trigger to something else.
#how will I store tracks? export dictionary with oggs.

#TODO: add overworld music

#collection of music tracks stored by string name.
@export var music_dict : Dictionary

#node that plays the tracks
@export var stream_player : AudioStreamPlayer

var current_track_name : String


@export var debug_tag : String = "music_player"

#autoloads
@onready var debug_hi : debug_helper = get_node("/root/debug_helper_auto")

func play_track(track_name : String):
	if track_name == current_track_name:
		debug_helper.db_message(" attempted to repeat track: " + track_name, debug_tag)
		return
	if track_name == "none":
		stream_player.stop()
		stream_player.stream = null
		current_track_name = track_name
		return
	if not music_dict.has(track_name):
		debug_helper.db_message(" music dict does not contain: " + track_name, debug_tag)
		return
	stream_player.stream = music_dict[track_name]
	stream_player.play()
	current_track_name = track_name

func stop_track():
	stream_player.stop()
	stream_player.stream = null
