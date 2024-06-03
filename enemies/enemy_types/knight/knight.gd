extends Node2D

#TODO: settable initial direction for the knight, for alert. I think I can just set the alvec for now though anyways.
#TODO: adjust iframes
#TODO: make them not walk into walls


#the knight only starts to move once the player enters a four directional tile adjacent to it.
#after that, it moves slowly in 4 directions

#asleep means theyre not doing anything, awake means purusing the player
#alerted is a temporary state between asleep and awake, wander is a state of moving that isn't locked 
#onto the player, reeling means that the player just struck them/knock back.
enum WakeState {ASLEEP, ALERTED, WANDER, AWAKE, REELING}

#movement vectors for different wake states
@export var alvec : Array[Vector2] = [Vector2(0,0), Vector2(0,1)]
var alindex : int = 0
var wvec : Vector2 = Vector2(0,0)
@export var awvec : Array[Vector2] = [Vector2(0,0), Vector2(0,1)]
var awindex : int = 0
var rvec : Vector2 = Vector2(0,0)

@export var wake_state : WakeState = WakeState.ASLEEP

@export_group("anim_info")
@export var knight_anim : AnimatedSprite2D
@export var idle_anim : String = "idle"
@export var up_anim : String = "up"
@export_group("","")

@export_group("collision")
@export var coll_areas : Array[Area2D]
@export_group("","")

@export_group("movement")
@export var alert_timer : Timer
@export var awake_timer : Timer
@export_group("","")


func _ready():
	pass
	
func _process(_delta):
	if wake_state == WakeState.AWAKE:
		pursue()
	if wake_state == WakeState.ALERTED:
		alert()
	if wake_state == WakeState.REELING:
		reel()
	
func pursue():
	position += awvec[awindex]
	awindex += 1
	if awindex >= awvec.size():
		awindex = 0

func change_pursuit():
	#just random 4 directions for now
	match randi_range(0,3):
		0:
			awvec[1] = Vector2(0,-1)
		1:
			awvec[1] = Vector2(0,1)
		2:
			awvec[1] = Vector2(-1,0)
		3:
			awvec[1] = Vector2(1,0)
	
func reel():
	#movement pattern representing being knocked back
	position += rvec

func alert():
	position += alvec[alindex]
	alindex += 1
	if alindex >= alvec.size():
		alindex = 0
	
func _on_up_wake_area_entered(_area):
	if wake_state == WakeState.ASLEEP:
		wake_state = WakeState.ALERTED
		alert_timer.start()

func _on_down_wake_area_entered(_area):
	if wake_state == WakeState.ASLEEP:
		wake_state = WakeState.ALERTED
		alert_timer.start()

func _on_left_wake_area_entered(_area):
	if wake_state == WakeState.ASLEEP:
		wake_state = WakeState.ALERTED
		alert_timer.start()

func _on_right_wake_area_entered(_area):
	if wake_state == WakeState.ASLEEP:
		wake_state = WakeState.ALERTED
		alert_timer.start()

func _on_alert_timer_timeout():
	#alert cycle finished, start awake state
	wake_state = WakeState.AWAKE
	awake_timer.start()

func _on_awake_timer_timeout():
	#randomize the direction of movement
	change_pursuit()

func _on_up_area_area_entered(area):
	if wake_state == WakeState.AWAKE:
		awvec[1].y *= -1

func _on_up_area_body_entered(body):
	if wake_state == WakeState.AWAKE:
		awvec[1].y *= -1

func _on_down_area_area_entered(area):
	if wake_state == WakeState.AWAKE:
		awvec[1].y *= -1

func _on_down_area_body_entered(body):
	if wake_state == WakeState.AWAKE:
		awvec[1].y *= -1

func _on_left_area_area_entered(area):
	if wake_state == WakeState.AWAKE:
		awvec[1].x *= -1

func _on_left_area_body_entered(body):
	if wake_state == WakeState.AWAKE:
		awvec[1].x *= -1

func _on_right_area_area_entered(area):
	if wake_state == WakeState.AWAKE:
		awvec[1].x *= -1

func _on_right_area_body_entered(body):
	if wake_state == WakeState.AWAKE:
		awvec[1].x *= -1

func _on_hurt_timer_timeout():
	#timer signifying the amount of time the knight should spend in the reeling state
	wake_state = WakeState.AWAKE

func _on_enemy_health_hurt():
	#activates when the enemy is hurt. 0
	wake_state = WakeState.REELING
