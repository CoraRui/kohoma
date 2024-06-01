extends Node2D
class_name heart

#this script is for a heart. when picked up, it restores a heart of the players health.

#TODO: add sfx?
#TODO: indication for close to despawn, change flicker rate?

@export var hp : int = 4

@onready var player_li : player_loader = get_node("/root/player_loader_auto")


func _on_expire_timer_timeout():
	queue_free()
