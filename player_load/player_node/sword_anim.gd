extends Node2D
class_name sword_anim

#does animations for the sword

@export_group("directional animsprites")
@export var up_sword : AnimatedSprite2D
@export var down_sword : AnimatedSprite2D
@export var left_sword : AnimatedSprite2D
@export var right_sword : AnimatedSprite2D
@export_group("","")

@export var swing_timer : Timer


func animate_sword(dir : int):

	match dir:
		0:
			up_sword.play("swing")
		1:
			down_sword.play("swing")
		2:
			left_sword.play("swing")
		3:
			right_sword.play("swing")
	swing_timer.start()

func _on_swing_timer_timeout():
	up_sword.play("notswing")
	down_sword.play("notswing")
	left_sword.play("notswing")
	right_sword.play("notswing")
