extends Node2D
class_name orb_sprite

#controls the movement of the orb sprite.
#shifts between different movement patterns using states, then switches between more basic types of movement
#within those states also state driven.


#TODO: movement patterns(splitting, charging, stunned)
#TODO: sfx
#TODO: animations
#TODO: 

#region states

@export_group("states")
#describes a movement set. identified as a movement pattern in the game. boss cycles between these, 
#and uses different ones at different phases throughout the fight.
#the charge pattern has the slime move up and down the area in columns,
#hopping to a different spot each time it hits a wall
#the hop pattern has it randomly hop side to side. while moving up and down.
#the stunned pattern plays some animation and sits there while the player hits it.
enum OrbState { IDLE_PATTERN, STUN_PATTERN, CHARGE_PATTERN, HOP_PATTERN }
@export var orb_state : OrbState = OrbState.IDLE_PATTERN
enum MoveState { IDLE, SLIDE, HOP }
@export var move_state : MoveState = MoveState.IDLE

@export_group("","")

#endregion

#movement patterns:
#split
#charge
#stunned
#side side
#slide towards point

#region exports
@export_group("slide parameters")
@export var slide_point : Node2D		#point that the orb will move towards while sliding.
@export var slide_vel : float = 2
@export_group("","")

@export_group("hop parameters")
@export var hop_point : Node2D
@export var hop_vel : float = 2
@export var hop_left : Node2D		#left bound of slime charge hopping
@export var hop_right : Node2D		#right bound of slime charge hopping
@export_group("","")

@export_group("charge pattern parameters")
#need a way to mark the height where the slide point will be put
#it doesn't need to finish the pattern though. it just needs to be higher than the wall so the area impacts.
#and directly up from the slimes current point.
@export var charge_top : int		#marks the upper y value that the charge point should be set to
@export var charge_bottom : int		#marks the lower y value 
@export var charge_slide_vel : int = 2				#velocity of charge slide
@export var charge_hop_vel : int = 2				#velocity of charge hop
@export var charge_anim : String = "charge"		#name of animation
@export var hop_var : int = 24		#maximum distance that the slime can hop in one direction. during the charge pattern anyways
@export_group("","")

#endregion

#region signals

signal slide_click		#slide reached its destination
signal hop_click

#endregion

@onready var player_li : player_loader = get_node("/root/player_loader_auto")

func _physics_process(_delta):
	move_state_matrix()

func move_state_matrix() -> void:
	#main matrix for movement pattern states
	#i dont know how to switch between them yet.
	match orb_state:
		OrbState.IDLE_PATTERN:
			pass
		OrbState.STUN_PATTERN:
			stun()
		OrbState.CHARGE_PATTERN:
			charge_pattern()
		OrbState.HOP_PATTERN:
			hop()

func init_battle() -> void:
	#starts the battle. gonna probably be triggered by some sort of external event.
	move_state = MoveState.SLIDE
	orb_state = OrbState.CHARGE_PATTERN
	charge_slide()
	

#region movement_patterns

func charge_pattern() -> void:
	#starting at top point:
	#go downwards until bottom collides with wall.
	#hop to left or right, start going up once hop is finished.
	#go until top is hit, hop to next spot
	#and so on.
	
	#use area signal or check manually?
	
	#slide and hop are initialized on wall area signal, or hop end signal
	match move_state:
		MoveState.SLIDE:
			slide()
		MoveState.HOP:
			hop()
	
func charge_hop() -> void:
	#initializes a hop. usually after the slime charges into a wall.
	#i assume youd just change the state and set the hop point to the desired value?
	#and how can I range limit ? do I want the shift to favor towards the center?
	#and do i want to exclude the outside? I think that it jumping into the wall isn't
	#very interesting. for now i can do a purely random range limited thing.
	#so generate a random value between +- hop_var. then range limit that value to be within the limits of the stage.
	
	debug_helper.db_message("charge hop", "boss_slime")
	
	#generates random value hop_var away from current x position, clamped between the left/rightmost hop limits
	hop_point.global_position = Vector2(clampi(int(global_position.x) + randi_range(-1 * hop_var, hop_var), int(hop_left.global_position.x), int(hop_right.global_position.x)), int(global_position.y))
	
	move_state = MoveState.HOP
	
func charge_slide() -> void:
	move_state = MoveState.SLIDE	#set move_state
	
	#sets the slide point to the opposite side of the screen
	if slide_point.global_position.y < 88:
		slide_point.global_position = Vector2(global_position.x, charge_bottom)

	else:
		slide_point.global_position = Vector2(global_position.x, charge_top)
	
	#set charge speed
	
	slide_vel = charge_slide_vel
	
func stun() -> void:
	pass

#endregion

#region primitive movements

func init_slide(sv : Vector2) -> void:
	#sets desired slide point and changes states
	slide_point.global_position = sv
	move_state = MoveState.SLIDE
	
func slide() -> void:
	#should be used to get orb into specific positions
	if global_position == slide_point.global_position:
		return
	
	global_position = global_position.move_toward(slide_point.global_position, slide_vel)
	
	if global_position == slide_point.global_position:
		slide_click.emit()

func init_hop() -> void:
	pass

func hop() -> void:
	#"hop" laterally towards a specific point.
	#right now hop is just going to use slide because its easier. well slides functions
	
	if global_position == hop_point.global_position:
		return
	
	global_position = global_position.move_toward(hop_point.global_position, hop_vel)
	
	
	if global_position == hop_point.global_position:
		debug_helper.db_message("hop clicked", "boss_slime")
		hop_click.emit()

#endregion

#region wall_collision signals
func _on_top_area_area_entered(_area):
	debug_helper.db_message("top area hit wall", "boss_slime")
	match orb_state:
		OrbState.CHARGE_PATTERN:
			match move_state:
				MoveState.SLIDE:
					charge_hop()
					
func _on_bottom_area_area_entered(_area):
	debug_helper.db_message("bottom area hit wall", "slime_boss")
	match orb_state:
		OrbState.CHARGE_PATTERN:
			match move_state:
				MoveState.SLIDE:
					charge_hop()
	
func _on_left_area_area_entered(_area):
	pass # Replace with function body.
	
func _on_right_area_area_entered(_area):
	pass # Replace with function body.

#endregion

#region primitive signals

func _on_hop_click():
	#fires when the hop movement gets to the hop point.
	#i guess that means that it should look at the current state info to calculate the next movement?
	match orb_state:
		OrbState.CHARGE_PATTERN:
			#if it just finished a hop pattern, and its in the charge state, start charging up or down
			#how to tell whether to go up or down. simple height check? should become clear once I set up the actual slide movement
			charge_slide()

func _on_slide_click():
	pass # Replace with function body.

#endregion

#connect body signals next. tilemaps are body dumbass
func _on_top_area_body_entered(body):
	pass # Replace with function body.
