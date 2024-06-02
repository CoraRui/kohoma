extends Node2D

#TODO: add animations: left right, hurt, atatcking
#TODO: add water shooting: spawn system for the bullet/shooting behaviour and the bullet itself
#TODO: movement behavior: attacked response, death response
#TODO: sfx: hurt, shooting, movement changes? nah


#control da whale

#the whale should slowly drift around in the water, occasionally speeding up their sprite anim then shooting a water droplet.

#reference to water droplet(I'm thinking it does an arc movement towards the player)
@export var water_ref : PackedScene

#average delay between shots
@export var drop_del : float = 4

var mvec : Vector2 = Vector2(1,1)
var fdel : int = 0

func _physics_process(_delta):
	if fdel > 0:
		move()
		fdel = 0
	else: 
		fdel += 1

func move():
	position += mvec
	
#i think the movement is just gonna be dvd logo.left pushes right, right pushes left, down up, up odwn.
func _on_top_area_entered(_area):
	mvec.y = 1

func _on_bottom_area_entered(_area):
	mvec.y = -1

func _on_left_area_entered(_area):
	mvec.x = 1

func _on_right_area_entered(_area):
	mvec.x = -1

func _on_top_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	mvec.y = 1

func _on_bottom_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	mvec.y = -1

func _on_left_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	mvec.x = 1

func _on_right_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	mvec.x = -1
