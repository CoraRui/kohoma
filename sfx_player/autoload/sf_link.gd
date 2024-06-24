extends Resource
class_name sf_link

#I'm thinking this resource should contain information to send to the sfx player in order to play a sound effect.
#most importantly the string name, but also, the volume, pitch, things like that.
#should I keep an activity variable in here?
#it would be a nice way to temporarily disable sound effects. this seems like a nice place to do it.
#meh. later. I can just use none in the sf_name for now.

@export var sf_name : String = "default"
@export var sf_vol : float = -1
@export var sf_pitch : float = 1.0


