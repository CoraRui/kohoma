extends Node2D

#the knight only starts to move once the player enters a four directional tile adjacent to it.
#after that, it moves slowly in 4 directions

#asleep means theyre not doing anything, awake means purusing the player
#alerted is a temporary state between asleep and awake, wander is a state of moving that isn't locked 
#onto the player, reeling means that the player just struck them/knock back.
#pause is a brief state before moving again usually after colliding with the wall
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
@export var player_prob_mod : float = 10
@export_group("","")

@export_group("alert_state")
@export var alert_timer : Timer
@export var alvec : Array[Vector2] = [Vector2(0,0), Vector2(0,0)]
var alindex : int = 0
@export_group("","")

@export_group("awake_state")
var wvec : Vector2 = Vector2(0,0)
@export var awvec : Array[Vector2] = [Vector2(0,0), Vector2(0,0), Vector2(0,0)]
var awindex : int = 0
@export_group("","")

@export_group("reeling_state")
@export var reel_timer : Timer
var rvec : Vector2 = Vector2(0,0)
@export_group("","")

@export_group("pause_state")
@export var pause_timer : Timer
@export_group("","")

@export_group("health")
@export var ehp_script : enemy_health
@export_group("","")


#endregion

#autoloads
@onready var player_li : player_loader = get_node("/root/player_loader_auto")

func _ready():
	pass
	
func _process(_delta):
	match knight_state:
		KnightState.AWAKE:
			pursue_move()
		KnightState.ALERTED:
			alert_move()
		KnightState.REELING:
			reel_move()
		KnightState.PAUSE:
			pass

func change_direction(d : DirClass.Dir):
	#should change the knight to go in the specified direction no matter what movement state
	
	knight_dir = d
	
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
	debug_helper.db_message("knight woke up", "enemies")
	knight_state = KnightState.AWAKE
	change_pursuit()
	awake_timer.start()
	knight_anim.play("awake")
	ehp_script.temp_inv = false

func pursue_move():
	position += awvec[awindex]
	awindex += 1
	if awindex >= awvec.size():
		awindex = 0

func change_pursuit():
	#this script should calculate the possibility for changes in certain directions.
	#two phases: prob calc, then roll

	#initialize base probability
	var up : int = 25
	var down : int = 25
	var left : int = 25 
	var right : int = 25
	
	#factor in player location. more likely to go in the players direction
	var to_player : Vector2 = global_position.direction_to(player_li.player_ins.global_position)
	
	up -= int(to_player.y * player_prob_mod)
	down += int(to_player.y * player_prob_mod)
	left -= int(to_player.x * player_prob_mod)
	right += int(to_player.x * player_prob_mod)
	
	#check if the knight is blocked on each side
	if up_area.has_overlapping_areas() || up_area.has_overlapping_bodies(): 
		up = 0
	if down_area.has_overlapping_areas() || down_area.has_overlapping_bodies(): 
		down = 0
	if left_area.has_overlapping_areas() || left_area.has_overlapping_bodies(): 
		left = 0
	if right_area.has_overlapping_areas() || right_area.has_overlapping_bodies(): 
		right = 0

	#total all probabilities
	var total : int = up+down+left+right
	
	var rand : int = randi_range(0,total)
	
	total -= up
	if total < rand:
		change_direction(DirClass.Dir.UP)
		return
	total -= down
	if total < rand:
		change_direction(DirClass.Dir.DOWN)
		return
	total -= left
	if total < rand:
		change_direction(DirClass.Dir.LEFT)
		return
	total -= right
	if total < rand:
		change_direction(DirClass.Dir.RIGHT)
		return

#KnightState.REEL
func reel():
	debug_helper.db_message("knight began reeling", "enemies")
	knight_state = KnightState.REELING
	reel_timer.start()
	knight_anim.play("reeling")
	
	#determine direction of reel(opposite player direction)
	var player_dir : Vector2 = global_position.direction_to(player_li.player_ins.global_position)
	
	if abs(player_dir.x) > abs(player_dir.y):
		rvec = Vector2(player_dir.x * -1, 0)
	else:
		rvec = Vector2(0, player_dir.y * -1)

func reel_move():
	#movement pattern representing being knocked back
	position += rvec

#KnightState.ALERTED
func alert():
	#changes state to alert
	knight_state = KnightState.ALERTED
	alert_timer.start()
	knight_anim.play("alert")

func alert_move():
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
		alert()

func _on_down_wake_area_entered(_area):
	if knight_state == KnightState.ASLEEP:
		alert()

func _on_left_wake_area_entered(_area):
	if knight_state == KnightState.ASLEEP:
		alert()

func _on_right_wake_area_entered(_area):
	if knight_state == KnightState.ASLEEP:
		alert()

func _on_alert_timer_timeout():
	#alert cycle finished, start awake state
	wake_up()

func _on_awake_timer_timeout():
	#randomize the direction of movement
	change_pursuit()

#endregion

#region wall_triggers
#wall triggers
func _on_up_area_area_entered(_area):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_up_area_body_entered(_body):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_down_area_area_entered(_area):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_down_area_body_entered(_body):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_left_area_area_entered(_area):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_left_area_body_entered(_body):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_right_area_area_entered(_area):
	if knight_state == KnightState.AWAKE:
		pause()

func _on_right_area_body_entered(_body):
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
	reel()

func _on_reel_timer_timeout():
	wake_up()
