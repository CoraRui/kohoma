extends Node2D

@export var bg_color : Color

@export var color_a : Color

@export var color_b : Color

#draw something

func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(176,176)), bg_color)
