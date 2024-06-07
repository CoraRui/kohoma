extends Node2D
class_name actor


#so I think that the way I'll create new actors is just by having a base actor object, then duplicating it and modifying that base thing.
#but pretty much all thats going to be here for now is the animatedsprite2d.
#sooo... yeah. and the actor script.

@export var actor_name : String = "default"

@export var actor_anim : AnimatedSprite2D
