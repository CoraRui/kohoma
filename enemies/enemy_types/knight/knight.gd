extends Node2D

#TODO: settable initial direction for the knight, for alert. I think I can just set the alvec for now though anyways.
#TODO: adjust iframes
#TODO: make them not walk into walls

#the knight only starts to move once the player enters a four directional tile adjacent to it.
#after that, it moves slowly in 4 directions

#asleep means theyre not doing anything, awake means purusing the player
#alerted is a temporary state between asleep and awake, wander is a state of moving that isn't locked 
#onto the player, reeling means that the player just struck them/knock back.
#pause is a brief state before moving again
enum KnightState {ASLEEP, ALERTED, WANDER, AWAKE, REELING, PAUSE}

#region export groups
@export_group("anim_info")
@export var knight_anim : AnimatedSprite2D
@export var idle_anim : String = "idle"
@export var up_anim : String = "up"
@export_group("","")

@export_group("collision")
@export var up_area : Area2D
@export var down_area : Area2D
@export var left_area : Area2D
@export var right_area : Area2D
@export_group("","")

@export_group("movement")
@export var knight_state : KnightState = KnightState.ASLEEP
@export var knight_dir : DirClass.Dir = DirClass.Dir.DOWN
@export var awake_timer : Timer
@export_group("","")

@export_group("alert_state")
@export var alert_timer : Timer
@export var alvec : Array[Vector2] = [Vector2(0,0), Vector2(0,1)]
var alindex : int = 0
@export_group("","")

@export_group("awake_state")
var wvec : Vector2 = Vector2(0,0)
@export var awvec : Array[Vector2] = [Vector2(0,0), Vector2(0,1)]
var awindex : int = 0
@export_group("","")

@export_group("reeling_state")
var rvec : Vector2 = Vector2(0,0)
@export_group("","")

@export_group("pause_state")
@export var pause_timer : Timer
@export_group("","")

#endregion

func _ready():
	pass
	
func _process(_delta):
	match knight_state:
		KnightState.AWAKE:
			pursue()
		KnightState.ALERTED:
			alert()
		KnightState.REELING:
			reel()
		KnightState.PAUSE:
			pass

func change_direction(d : DirClass.Dir):
	#should change the knight to go in the specified direction no matter what movement state
	match knight_dir:
		DirClass.Dir.UP:
			awvec[0] = Vector2(0,-1)
		DirClass.Dir.DOWN:
			awvec[0] = Vector2(0,1)
		DirClass.Dir.LEFT:
			awvec[0] = Vector2(-1,0)
		DirClass.Dir.RIGHT:
			awvec[0] = Vector2(1,0)

#KnightState.AWAKE
func wake_up():
	#changes the knight to the KnightState.AWAKE state
	knight_state = KnightState.AWAKE
	change_pursuit()
	awake_timer.start()

func pursue():
	position += awvec[awindex]
	awindex += 1
	if awindex >= awvec.size():
		awindex = 0

func change_pursuit():
	#just random 4 directions for now
	
	var rand_array : Array[DirClass.Dir] 
	
	#check if the knight is blocked on each side
	
	if not(up_area.has_overlapping_areas() || up_area.has_overlapping_bodies()): 
		rand_array.append(DirClass.Dir.UP)
		
	if not(down_area.has_overlapping_areas() || down_area.has_overlapping_bodies()): 
		rand_array.append(DirClass.Dir.DOWN)
	
	if not(left_area.has_overlapping_areas() || left_area.has_overlapping_bodies()): 
		rand_array.append(DirClass.Dir.LEFT)
	
	if not(right_area.has_overlapping_areas() || right_area.has_overlapping_bodies()): 
		rand_array.append(DirClass.Dir.RIGHT)
	
	
	match randi_range(0,rand_array.size()):
		0:
			change_direction(rand_array[0])
		1:
			change_direction(rand_array[1])
		2:
			change_direction(rand_array[2])
		3:
			change_direction(rand_array[3])

#KnightState.REEL
func reel():
	#movement pattern representing being knocked back
	position += rvec

#KnightState.ALERTED
func alert():
	position += alvec[alindex]
	alindex += 1
	if alindex >= alvec.size():
		alindex = 0

#KnightState.PAUSE
func pause():
	#should pause the knight for a second or two, then return to the alerted state
	knight_state = KnightState.PAUSE
	pause_timer.start()
	
#region wake_triggers
#wake triggers
func _on_up_wake_area_entered(_area):
	if knight_state == KnightState.ASLEEP:
		knight_state = KnightState.ALERTED
		alert_timer.start()

func _on_down_wake_area_entered(_area):
	if knight_state == KnightState.ASLEEP:
		knight_state = KnightState.ALERTED
		alert_timer.start()

func _on_left_wake_area_entered(_area):
	if knight_state == KnightState.ASLEEP:
		knight_state = KnightState.ALERTED
		alert_timer.start()

func _on_right_wake_area_entered(_area):
	if knight_state == KnightState.ASLEEP:
		knight_state = KnightState.ALERTED
		alert_timer.start()

func _on_alert_timer_timeout():
	#alert cycle finished, start awake state
	knight_state = KnightState.AWAKE
	awake_timer.start()

func _on_awake_timer_timeout():
	#randomize the direction of movement
	change_pursuit()

#endregion

#region wall_triggers
#wall triggers
func _on_up_area_area_entered(area):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_up_area_body_entered(body):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_down_area_area_entered(area):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_down_area_body_entered(body):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_left_area_area_entered(area):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_left_area_body_entered(body):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_right_area_area_entered(area):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_right_area_body_entered(body):
	if knight_state == KnightState.AWAKE:
		pause()

#endregion

func _on_pause_timer_timeout():
	wake_up()
	
#health triggers
func _on_hurt_timer_timeout():
	#timer signifying the amount of time the knight should spend in the reeling state
	knight_state = KnightState.AWAKE

func _on_enemy_health_hurt():
	#activates when the enemy is hurt. 0
	knight_state = KnightState.REELING

