extends Node2D

#I think I was just testing around with how to draw stuff through script?
#anyways I'll probably remove this later


@export var bg_color : Color

@export var color_a : Color

@export var color_b : Color

#draw something

func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(176,176)), bg_color)
