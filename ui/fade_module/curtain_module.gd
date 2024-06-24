extends Node2D
class_name curtain_module

#this autoload should handle the curtain effect. namely turning the entire screen white for a moment
#while the screen changes.

enum CurtainState { INACTIVE, FADEOUT, HOLD, FADEIN, DONE}

var curtain_state : CurtainState = CurtainState.INACTIVE

#region exports

@export_group("self references")
@export var fade_out_timer : Timer		#timer for hiding phase
@export var hold_timer : Timer			#timer for hold phase
@export var fade_in_timer : Timer		#timer for revealing phase
@export var curtain_rect : ColorRect
@export_group("","")

@export_group("timing parameters")
@export var fade_in_del : float = 0.3 :
	get:
		return fade_in_del
	set(v):
		fade_in_timer.wait_time = v
		fade_in_del = v
@export var hold_del : float = 1.2 :
	get:
		return hold_del
	set(v):
		if not is_node_ready():
			await ready
		hold_timer.wait_time = v
		hold_del = v	
@export var fade_out_del : float = 0.3 :
	get:
		return fade_out_del
	set(v):
		if not is_node_ready():
			await ready
		fade_out_timer.wait_time = v
		fade_out_del = v
@export var fade_out_speed : float = 0.1
@export var fade_in_speed : float = 0.1
@export_group("","")

#endregion

@export var debug_name : String = "curtain"
@onready var debug_hi : debug_helper = get_node("/root/debug_helper_auto")
@onready var camera_li : camera_loader = get_node("/root/camera_loader_auto")

func _physics_process(_delta):
	curtain_state_cross()

func curtain_state_cross():
	match curtain_state:
		CurtainState.FADEOUT:
			proc_fade_out()
		CurtainState.HOLD:
			proc_hold()
		CurtainState.FADEIN:
			proc_fade_in()
		CurtainState.DONE:
			pass
		CurtainState.INACTIVE:
			pass
		_:
			debug_hi.db_message("curtain_state has a weird value. why tho", debug_name)

func proc_fade_out():
	curtain_rect.color.a = clampf(curtain_rect.color.a + fade_out_speed, 0, 1)

func proc_hold():
	pass

func proc_fade_in():
	curtain_rect.color.a = clampf(curtain_rect.color.a - fade_in_speed, 0, 1)

#region state_shifts
func init_shift():
	init_fade_out()

func init_fade_out():
	fade_out_timer.start()
	curtain_state = CurtainState.FADEOUT
	curtain_rect.color.a = 0

func init_hold():
	hold_timer.start()
	curtain_state = CurtainState.HOLD

func init_fade_in():
	fade_in_timer.start()
	curtain_state = CurtainState.FADEIN

func init_done():
	curtain_state = CurtainState.INACTIVE

#endregion

#region phase timer signals

func _on_fade_out_timeout():
	init_hold()

func _on_hold_timeout():
	init_fade_in()

func _on_fade_in_timeout():
	init_done()

#endregion

