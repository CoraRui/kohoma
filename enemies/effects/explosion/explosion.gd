extends Node2D

#just plays an animation until the timer queues the whole node free.

@export var main_anim : AnimatedSprite2D
@export var exp_timer : Timer

func _on_exp_timer_timeout():
	queue_free()
