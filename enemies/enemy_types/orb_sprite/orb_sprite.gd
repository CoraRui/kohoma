extends Node2D


#TODO: movement patterns(splitting, charging, stunned)
#TODO: sfx
#TODO: animations
#TODO: 


enum OrbState { SLIDE }
var orb_state : OrbState = OrbState.SLIDE

#movement patterns:
#split
#charge
#stunned
#side side
#slide towards point


#slide state
@export var slide_point : Node2D		#point that the orb will move towards while sliding.

func _physics_process(_delta):
	move_state()

func move_state() -> void:
	match orb_state:
		OrbState.SLIDE:
			slide()

#movement patterns
func slide():
	pass
