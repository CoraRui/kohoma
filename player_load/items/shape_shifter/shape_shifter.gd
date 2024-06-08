extends Node2D

#this script should allow the player to "shape shift"
#it basically is just another thing that allows the player to interact with the environment in different ways.

#for right now I'll just link it to the number keys.
#I'll attach a certain couple of things to disable/set invisible

@export var anim_script : AnimatedSprite2D

@export var player_move : player_movement

@export var player_items : items



func _input(event):
	if event.is_action_pressed("row_one"):
		print("shift to hero")
	if event.is_action_pressed("row_two"):
		print("")

