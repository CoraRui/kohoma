extends Node2D


#this script should spawn enemies in definite positions rather than random ones.
#I only really need a spawner script like this because I don't want to 
#have to write a camera snap delay thing in like everything I program, and I'm sure theres
#some extra functionality i can add this way.

@export var enemy_arr : Array[enemy_set]

@export var spawn_points : Array[Node2D]


#autoload
@onready var camera_li : camera_loader = get_node("/root/camera_loader_auto")
@onready var world_li : world = get_node("/root/world_auto")

func _ready():
	camera_li.camera_snapped.connect(spawn_enemies)

func spawn_enemies():
	for e in enemy_arr:
		var ne : Node2D = e.enemy_ref.instantiate()
		world_li.current_level.add_child(ne)
		ne.global_position = spawn_points[e.spawn_index].global_position

