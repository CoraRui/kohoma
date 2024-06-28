extends Node2D
class_name spike

#TODO: relocate area 2d to be attached on instance
#this script should damage the player if they touch the hitbox.
#I should have a hitbox on the player that looks for damage sources rather than 
#having each enemy look for the player.

@export var damage : int = 1

@export var spike_area : Area2D

@export var spike_active : bool = true

func toggle_spike(b : bool) -> void:
	spike_active = b
