extends Node2D
class_name heart

#this script is for a heart. when picked up, it restores a heart of the players health.
#I think this will probably be the only health drop.
#If healing multiple hearts is desired, just spawn multiple, or maybe there'll be a fairy or something idk.

#TODO: add sfx?
#TODO: fine tune animation timing



@export var hp : int = 4				#i really dont think this will change. but whatever

#region animation

@export_group("animation")
@export var heart_anim : AnimatedSprite2D		#animated sprite node
@export var anim_one : String = "heart_one"		#name of first phase animation
@export var anim_two : String = "heart_two"		#name of second phase animation
@export var phase_timer : Timer					#this timer is used to time the phases of animation. probably just slow flash then quicker flash.
@export var p1_length : float = 3				#length of first animation phase
@export var p2_length : float = 3				#length of second animation phase
@export_group("","")

#endregion

#region sfx

@export_group("sfx")
@export var pickup_sf_link : sf_link		#link to sound effect for heart pickup
@export_group("","")

#endregion

#region autoloads

@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

#endregion

func _ready():
	heart_anim.play(anim_one)
	phase_timer.wait_time = p1_length
	phase_timer.start()

func _on_expire_timer_timeout():
	queue_free()

func _on_phase_timer_timeout():
	heart_anim.play(anim_two)
