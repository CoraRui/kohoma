extends Node2D

#this script has the fish jump out of the water at random intervals.
#probably also going to be influenced by the phase of the fight.
#faster/slower spawn rate, temporarily disable etc.
#essentially, i want two areas that can spawn fish within a certain range.
#since they're just rectangles i can use two node2d then just have the fish spawn in between them
#could the players location affect the spawn area? id probably want more fish near the player
#maybe the fish could be helping the player. theyd be like jumping out of the water like
#"hey! pick me! pick me!" and so on and so forth


#each fish jump has a top and bottom corner
#fish will be spawned randomly as a position within that box
#jsut at top left for now
#at randomized intervals

@export var tl_node : Node2D					#top left limit of fish spawn area
@export var br_node : Node2D					#bottom right limit of fish spawn area

@export var spawn_interval : float = 4.2		#time between fish spawns
@export var spawn_var : float = 1.1				#variance between fish spawns

@export var spawn_timer : Timer					#timer that activates a fish spawn

@export var fish_ref : PackedScene

@onready var world_i : world = get_node("/root/world_auto")

func _ready():
	spawn_timer.start()

func spawn_fish() -> void:
	var new_fish : Node2D = fish_ref.instantiate()
	
	#generate position
	new_fish.global_position = Vector2(randi_range(tl_node.global_position.x, br_node.global_position.x), randi_range(tl_node.global_position.y, br_node.global_position.y))
	world_i.current_level.add_child(new_fish)

func _on_spawn_timer_timeout():
	spawn_fish()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

