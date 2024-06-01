extends Node2D
class_name sfx_player

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



