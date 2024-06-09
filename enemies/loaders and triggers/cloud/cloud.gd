extends Node2D
class_name cloud

#this script should take an enemy then spawn it after a short period of time.


@export var enemy_ref : PackedScene
@export var cloud_anim_name : String
@export var cloud_anim : AnimatedSprite2D
@export var spawn_timer : Timer
@export var exp_timer : Timer

#autoloads
@onready var world_li : world = get_node("/root/world_auto")

func _ready():
	cloud_anim.play(cloud_anim_name)
	spawn_timer.start()
	exp_timer.start()
	
func spawn_enemy():
	var new_enemy : Node2D = enemy_ref.instantiate()
	world_li.current_level.add_child(new_enemy)
	new_enemy.global_position = global_position		#assumes that the cloud is in the desired position

func _on_spawn_timer_timeout():
	#TODO: animation change when enemy spawns, for now just stop the anim
	spawn_enemy()
	cloud_anim.play("post_spawn")

func _on_exp_timer_timeout():
	queue_free()
