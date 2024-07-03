extends Resource
class_name music_link

#this resource should hold information to find and play a certain song. pretty much just a string.
#but it also holds some information to adjust the playing of that song.
#so if I want the music to be a little quieter in a certain instance, i can quickly edit that with a music link.
#just be careful that the song might already be modified in editor. so you'll have to take care to
#combine those changes properly in the music player node.

@export var song_name : String = "default_name"

@export var vol : float = 0

@export var pitch : float = 0

@export var speed : float = 0

