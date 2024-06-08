extends Node2D
class_name actor


#so I think that the way I'll create new actors is just by having a base actor object, then duplicating it and modifying that base thing.
#but pretty much all thats going to be here for now is the animatedsprite2d.
#sooo... yeah. and the actor script.

enum ActorState {MOVE, STAY}
var actor_state : ActorState = ActorState.STAY

@export var actor_name : String = "default"
@export var actor_anim : AnimatedSprite2D


#movement parameters
var mvec_arr : Array[Vector2] = [Vector2(0,0), Vector2(0,0)]
var mvec_index : int = 0
var mvec_dist : int = 0


func _process(_delta):
	move()

func block_to(comm : cin_comm):
	actor_state = ActorState.MOVE
	mvec_arr = comm.block_vel
	mvec_dist = comm.block_dist

func move():
	#move the actor for this frame
	if not (actor_state == ActorState.MOVE):
		return
	position += mvec_arr[mvec_index]
	mvec_dist -= abs(mvec_arr[mvec_index].x)		#increments distance travelled for later
	mvec_dist -= abs(mvec_arr[mvec_index].y)		#uses x and y cause one of them is zero anyways
	mvec_index += 1
	if mvec_index >= mvec_arr.size():
		mvec_index = 0
		
	#check distance travelled and stop movement if the desired distance is reached.
	if mvec_dist <=0:
		actor_state = ActorState.STAY


