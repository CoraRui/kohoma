extends Node2D
class_name bobber

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

@export_group("arc parameters")
#abbrevations are the current progress, full names are frames in each phase
var rfp : int = 0
@export var rise_frames : int = 30
var flfp : int = 0
@export var float_frames : int = 30
var fafp : int = 0
@export var fall_frames : int = 30
@export_group("","")

enum ArcPhase{RISE, FLOAT, FALL, GND}
var arc_phase : ArcPhase = ArcPhase.RISE

func _physics_process(_delta):
	move_bobber()

func move_bobber():
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
		







