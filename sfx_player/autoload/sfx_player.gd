extends Node2D
class_name sfx_player

#TODO: add volume to individual sound clips and some kind of label to add to things trying to play sounds.
#basically, come up with some way to control volume of sound effects on an individual level.

#this autoload contains functions for playing short sound effects.
#
#how many different sounds should be able to play at the same time?
#im thinking like four.

@export var sfx_streams : Array[AudioStreamPlayer]
var sf_index : int = 0


@export var sfx_dict : Dictionary

func play_sound(sn : String):
	#so this function should put the sound named sn into the next stream player and play it.
	if not sfx_dict.has(sn):
		print("sfx player attempted to play nonexistent sound:", sn)
		return
	
	sfx_streams[sf_index].stream = sfx_dict[sn]
	sfx_streams[sf_index].play()

	sf_index += 1
	if sf_index >= sfx_streams.size():
		sf_index = 0

func play_sound_link(sfl : sf_link):
		#so this function should put the sound named sn into the next stream player and play it.
	if not sfx_dict.has(sfl.sf_name):
		print("sfx player attempted to play nonexistent sound:", sfl.sf_name)
		return
	
	sfx_streams[sf_index].stream = sfx_dict[sfl.sf_name]
	sfx_streams[sf_index].play()
	sfx_streams[sf_index].volume_db = sfl.sf_vol
	sf_index += 1
	if sf_index >= sfx_streams.size():
		sf_index = 0

