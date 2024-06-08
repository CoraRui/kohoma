extends Resource
class_name sf_link

#I'm thinking this resource should contain information to send to the sfx player in order to play a sound effect.
#most importantly the string name, but also, the volume, pitch, things like that.

@export var sf_name : String = "default"
@export var sf_vol : float = -1
@export var sf_pitch : float = 1.0


