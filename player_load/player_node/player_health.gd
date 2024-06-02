extends Node2D
class_name player_health

#contains a value for the players health, and activates death trigger when health is zero

#health values
@export var mhp : int = 12
@export var hp : int = 12

@export var hitbox : Area2D

@export var i_frames : Timer

@export var half_hurt_sf : String = "p_hurt_med"
@export var heal_sf : String = "p_heal"

#invincible
var inv : bool = false
#autoloads

@onready var death_ti : death_trigger = get_node("/root/death_trigger_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

func _ready():
	hp = save_fi.current_file.hp
	mhp = save_fi.current_file.mhp

func damage(dp : int):
	if inv : 
		return
	hp -= dp
	stat_bi.update_health(hp, mhp)
	if hp <=0:
		death_ti.game_over()
	else:
		i_frames.start()
		inv = true
	sfx_pi.play_sound(half_hurt_sf)

func heal(nhp : int):
	hp += nhp
	hp = clampi(hp,0,mhp)
	stat_bi.update_health(hp, mhp)
	sfx_pi.play_sound(heal_sf)
	

func check_for_hit(area : Area2D):
	if area.get_parent() is spike:
		damage(area.get_parent().damage)
		print(area.get_parent().name)
		
func _on_hit_area_area_entered(area):
	check_for_hit(area)
	if area.get_parent() is heart:
		heal(area.get_parent().hp)
		area.get_parent().queue_free()

func _on_i_frames_timeout():
	inv = false
	if hitbox.has_overlapping_areas():
		check_for_hit(hitbox.get_overlapping_areas()[0])








