extends Resource
class_name cin_comm

#TODO: add some sort of broad advance trigger which can advance on a certain signal?
#right now, I'm gonna outline all of the commands in the way that I want to be able to set them.
#then I'll try to see if it actually works out that way.

#region blocking
#hrm will i be able to move multiple things/have multiple commands in progress at the same time?
@export_group("blocking")
@export var move_actor : bool = false				#whether to move an actor this command.
@export var move_actor_name : String = "default"			#name of character to move.
@export var block_dist : int = 16							#distance to be travelled
@export var block_vel : Array[Vector2] = [Vector2(0,0)]
@export_group("","")
#endregion

#region animation
@export_group("animation")
@export var animate_actor : bool = false			#whether to actually animate the actor
@export var anim_actor_name : String = "default"
@export var anim_name : String = "default"			#name of animation in actor to switch to
@export_group("","")
#endregion

#region dialogue
@export_group("dialogue")
@export var init_dialogue : bool = false				#shows the dialogue box
@export var close_dbox : bool = false				#closes the dialogue box
@export var dialogue_obj : dialogue					#dialogue to be passed to the dialogue loader.
#TODO: add dialogue animation
#im not exactly sure how the dialogue animation bit will work yet...
#but I'm pretty sure it will be referenced by name. something like the dbox having references to a 
#couple of different animatedsprite2D nodes which it can load in and out by name, then
@export_group("","")

#endregion

#region player input
@export_group("player_input")
@export var set_input : bool = false			#determines whether to use the following three.
@export var movement_disabled : bool = false	#disables movement/items/attacking of the player
@export var pause_disabled : bool = false		#disables opening the pause menu
@export var inventory_disabled : bool = false	#disables opening inventory
@export_group("","")
#endregion

#region next triggers
@export_group("next_trigger")
@export var jump_to_index : bool = false
@export var jump_index : int = 0
@export var advance_immediately : bool = true		#causes the handler execute the next command as soon as this one is finished.
@export var advance_timer : bool = false				#links the execution of the next command to the command timer.
@export var advance_delay : float = 3.0				#time to wait before execution of next command
@export var advance_input : bool = false			#waits for the player to press a specific button to start the next command.
@export var advance_dbox : bool = false				#waits until the dbox is finished displaying before starting the next command.
@export_group("","")

#endregion

