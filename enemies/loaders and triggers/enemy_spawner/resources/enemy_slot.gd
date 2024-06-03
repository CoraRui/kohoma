extends Resource
class_name enemy_slot
#this resource contains info for a single enemy in the enemy spawner.
#contains unique info about this enemy type, mainly their spawning odds.

#this number gets added in with all of the other enemies spawn chances in the enemyspawner to determine the odds of this enemy spawning
@export var spawn_chance : int = 25

@export var enemy_ref : PackedScene



