extends Node2D
class_name bobber

#TODO: add area2d and search for certain types of things, likely enemies and mechanisms. then search for a hook module.
#TODO: add different lengths for charging the cast strength
#TODO: change yloc dependent on progress in arc, likely on a timer.

#so how do I have the bobber move? its going to move itself. but the reel is going to pass it some info.
#it should get the direction.

#should travel in a prewritten arc dependent on the current direction of the player
#once it reaches the end of that arc, or it hits something, it should
#change state to hooked. eventually i'll probably have a timer so that it will be "high" or "low",
#to hit enemies in the air earlier in the arc, and ground enemies later in the arc

@export var hvel_one : Array[int]

#determines which direction the bobber will travel
enum ArcDir {UP, DOWN, LEFT, RIGHT}

#mainly to determine how the bobber will react when its high in the air vs lower vs on the ground
enum YLoc {HIGH, LOW, GND}
var y_loc : YLoc = YLoc.LOW

@export_group("arc parameters")
#abbrevations are the current progress, full names are frames in each phase
var rfp : int = 0
@export var rise_frames : int = 30
var flfp : int = 0
@export var float_frames : int = 30
var fafp : int = 0
@export var fall_frames : int = 30
@export_group("","")

enum ArcPhase{RISE, FLOAT, FALL, GND, HOOK}
var arc_phase : ArcPhase = ArcPhase.RISE

var hook_mod_ins : hook_module

func _physics_process(_delta):
	move_bobber()

func move_bobber() -> void:
	if arc_phase == ArcPhase.GND:
		return
	if arc_phase == ArcPhase.RISE:
		position += Vector2(1,-1)
		rfp += 1
		if rfp > rise_frames:
			arc_phase = ArcPhase.FLOAT
	elif arc_phase == ArcPhase.FLOAT:
		position += Vector2(1,0)
		flfp += 1
		if flfp > float_frames:
			arc_phase = ArcPhase.FALL
	elif arc_phase == ArcPhase.FALL:
		position += Vector2(1,1)
		fafp += 1
		if fafp > fall_frames:
			arc_phase = ArcPhase.GND
		
func hook_to(hm : hook_module) -> void:
		hook_mod_ins = hm
		hook_mod_ins.hook.emit()
		y_loc = hook_mod_ins.y_loc
		arc_phase = ArcPhase.HOOK
		#TODO: i think i did this reparent wrong
		get_parent().remove_child(self)
		hook_mod_ins.add_child(self)
		position = hook_mod_ins.hook_point.position
		
func _on_bobber_area_area_entered(area):
	#should search for enemies and mechanisms for hook points
	for c in area.get_parent().get_children():
		if c is hook_module:
			hook_to(c)
	







