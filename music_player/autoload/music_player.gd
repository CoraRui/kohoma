extends Node2D
class_name music_player

#this autoload plays music. should be activated by a trigger node.
#for the most part those trigger nodes will be put in certain levels and rooms, and simply play on ready.
#for exact timing though, I can just use timers to delay the start of the music, or link the trigger to something else.
#how will I store tracks? export dictionary with oggs.
#it plays music from the one stream player thats attached. not like the sfx player which creates and destroys multiple.
#so it should be easier to modify things by script, like volume.


#TODO: add lots and lots of music
#TODO: adjustable volume by track
#TODO: adjustable volume on play call
#so i think for music its mainly going to be on play. but I'd like functions to change the music
#at any time as well.

#region exports

@export var song_dict : Dictionary

@export var stream_player : AudioStreamPlayer

@export_group("stream player parameters")
@export var max_vol_db : float = 1
@export var min_vol_db : float = -1000
@export_group("","")

#internals
var current_track_name : String = "none"
var debug_tag : String = "music_player"

@export_group("archived")
#putting things here that need to eventually be removed
@export var music_dict : Dictionary

@export_group("","")

#endregion

#region play functions

func play_track(track_name : String):
	debug_helper.db_message("play track was called. should use play_music_link instead", "music")
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

func play_music_link(ml : music_link):
	
	#prevent repeated tracks
	if ml.song_name == current_track_name:
		debug_helper.db_message(" attempted to repeat track: " + ml.song_name, debug_tag)
		return
	
	#stops track if using codeword none
	if ml.song_name == "none":
		stop_track()
		current_track_name = ml.song_name
		return
	
	#checks if the song exists
	if not song_dict.has(ml.song_name):
		debug_helper.db_message(" music dict does not contain: " + ml.song_name, debug_tag)
		return
	
	#modifies the stream player with values from the song_packet and music_link
	#most values are additive since they will be affected by the song packet and the music link
	
	stream_player.volume_db += ml.vol
	stream_player.volume_db += song_dict[ml.song_name].vol
	
	#add pitch/speed modifiers as well
	
	#actually plays the song
	stream_player.stream = song_dict[ml.song_name]
	stream_player.play()
	current_track_name = ml.song_name
	
func adjust_volume(dv : float) -> void:
	#it doesn't look like audio streams have their own volume settings. 
	#so if I want to adjust songs by volume in editor, ill have to create some sort of resource for it.
	#this function just adds to the decibel volume of the stream player, regardless of other settings.
	stream_player.volume_db = clampf(stream_player.volume_db + dv, min_vol_db, max_vol_db)

#endregion
