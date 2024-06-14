extends AnimatedSprite2D
class_name player_anim

@export_group("anim_names")
@export var walk_up : String = "walk_up"
@export var walk_down : String = "walk_down"
@export var walk_left : String = "walk_left"
@export var walk_right : String = "walk_right"
@export_group("","")



func animate_movement(mvec : Vector2):
	#takes the movement vector from the movement script and determines players movement animation.
	match mvec:
		Vector2(0,-1):
			play(walk_up)
		Vector2(0,1):
			play(walk_down)
		Vector2(-1,0):
			play(walk_left)
		Vector2(1,0):
			play(walk_right)
		Vector2(0,0):
			pause()
			frame = 1

