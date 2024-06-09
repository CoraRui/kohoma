extends Node2D

#controls the explosion effect.
#should essentially just play the animation for a moment and suicide

@export var main_anim : AnimatedSprite2D

@export var exp_timer : Timer

func _on_exp_timer_timeout():
	queue_free()
