extends Resource
class_name song_packet

#this resource should hold info for a song. should be used by music player.gd to store songs.
#mainly to store volume/pitch/tempo along with a song. 

@export var song_file : AudioStreamOggVorbis

@export var vol : float = 0

@export var pitch : float = 0

@export var speed : float = 1

