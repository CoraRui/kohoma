extends Node2D
class_name player_health

#contains a value for the players health, and activates death trigger when health is zero

#health values
@export var mhp : int = 12
@export var hp : int = 12
@export var hitbox : Area2D						#area which player can be damageds
@export var i_frames : Timer					#timer for invincibility
@export var half_hurt_sf : String = "p_hurt_med"	#sound effect for a half heart damage
@export var heal_sf : String = "p_heal"				#sound effect for being healed
@export var inv_vis_flash_interval : int = 3
@export var inv_invis_flash_interval : int = 3
var inv_flash_index : int = 0

@export var anim_node : AnimatedSprite2D
@export var move_node : player_movement

#internal 
var inv : bool = false

#region autoloads
@onready var death_ti : death_trigger = get_node("/root/death_trigger_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
#endregion

func _ready():
	hp = save_fi.current_file.hp
	mhp = save_fi.current_file.mhp

func _input(event):
	if event.is_action_pressed("debug_one"):
		damage(100, player_li.player_ins.global_position)

func _physics_process(_delta):
	i_frame()

func damage(dp : int, pos : Vector2):
	#damages player, pos is passed to determine the direction of knockback
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
	move_node.trigger_hurt(pos)

func heal(nhp : int):
	hp += nhp
	hp = clampi(hp,0,mhp)
	stat_bi.update_health(hp, mhp)
	sfx_pi.play_sound(heal_sf)

func check_for_hit(area : Area2D):
	if area.get_parent() is spike:
		if area.get_parent().spike_active:	damage(area.get_parent().damage, area.global_position)

func i_frame():
	if !inv:
		return
	inv_flash_index += 1
	if inv_flash_index >= inv_vis_flash_interval && anim_node.is_visible():
		inv_flash_index = 0
		anim_node.set_visible(!anim_node.is_visible())
	if inv_flash_index >= inv_invis_flash_interval && !anim_node.is_visible():
		inv_flash_index = 0
		anim_node.set_visible(!anim_node.is_visible())
	
#region signals

func _on_hit_area_area_entered(area):
	check_for_hit(area)
	if area.get_parent() is heart:
		heal(area.get_parent().hp)
		area.get_parent().queue_free()

func _on_i_frames_timeout():
	inv = false
	#TODO: no idea how but the get index 0 was apparently out of bounds here at some ponit. idk
	if hitbox.has_overlapping_areas():
		check_for_hit(hitbox.get_overlapping_areas()[0])
	anim_node.set_visible(true)

#endregion





