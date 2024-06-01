extends Node2D

#TODO: fine tune sword timing
#TODO: player animations simultaneously
#TODO: better sfx
#TODO: minor, but possibly add reactions to minor things, like drifting away from heavy objects?

var pdir : int 

@export var sword_areas : Array[Area2D]

@export var dmg : int = 5

@export var hit_frames : int = 15

@export_group("signals")
signal started_swing
signal ended_swing
@export_group("","")

#current frame count of swing.
var hf_count : int = 0
#which direction the player is facing: udlr,0123
var dir : int = 0
var swinging : bool = false

var swing_sfx : String = "p_sword_swing"

#autoloads

@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

func _physics_process(_delta):
	if swinging:
		check_frames()

func check_frames():
	hf_count += 1
	if hf_count >= hit_frames:
		end_swing()
		return
	check_area(sword_areas[dir])
	
func end_swing():
	ended_swing.emit()
	for a in sword_areas:
		a.get_parent().set_visible(false)
	swinging = false
	hf_count = 0

func _input(event):
	dir_check()
	if event.is_action_pressed("attack"):
		if not swinging:
			swing()
		else:
			end_swing()
			swing()

func dir_check():
		var x : int = int(Input.get_axis("left", "right"))
		var y : int = int(Input.get_axis("down", "up"))
		if y == 0:
			if x == -1:
				dir = 2
			if x == 1:
				dir = 3
		else:
			if y == -1:
				dir = 1
			if y == 1:
				dir = 0

func swing():
	started_swing.emit()
	sword_areas[dir].get_parent().set_visible(true)
	check_area(sword_areas[dir])
	swinging = true
	sfx_pi.play_sound(swing_sfx)

func check_area(a : Area2D):
	for area in a.get_overlapping_areas():
		for h in area.get_parent().get_children():
			if h is enemy_health:
				h.damage(dmg)
	
	
	
	
	
	
	
	
	
	
	
	
	
