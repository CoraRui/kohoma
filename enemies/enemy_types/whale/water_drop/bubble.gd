extends Node2D
class_name bubble

#this script should just point the bubble towards the character and move it in that direction
#until the decay timer runs out


@export var dur_timer : Timer			#timer controlling bubbles lifetime

@onready var player_li : player_loader = get_node("/root/player_loader_auto")

var init_dir : Vector2

func _physics_process(_delta):
	move()

func init_bubble():
	dur_timer.start()
	init_dir = global_position.direction_to(player_li.player_ins.global_position)
	
func move():
	position += init_dir

func end_bubble():
	queue_free()

func _on_dur_timer_timeout():
	end_bubble()
