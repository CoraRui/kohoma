extends Node2D


#four phases:
#init, flash, boom, clear


@export var boom_sf : sf_link

@export var boom_area : Area2D

@export var auto_light : bool = true

@export_group("timing")
@export var init_timer : Timer		#time from init to flash
@export var flash_timer : Timer		#timer from flash to explosion
@export var boom_timer : Timer 		#timer from explosion to clear
@export var clear_timer : Timer
@export_group("","")

@export_group("animation")
@export var boom_anim : AnimatedSprite2D
@export var exp_name : String = "boom"
@export var flash_name : String = "flash"
@export var idle_name : String = "idle"
@export_group("","")

func _ready():
	if auto_light:
		init_timer.start()
	boom_anim.play(idle_name)

func _on_init_timer_timeout():
	boom_anim.play(idle_name)
	flash_timer.start()

func _on_flash_timer_timeout():
	boom_anim.play(flash_name)
	boom_timer.start()

func _on_boom_timer_timeout():
	boom_anim.play(exp_name)
	clear_timer.start()
	#activate_bomb_area
	boom_area.get_child(0).disabled = false

func _on_clear_timer_timeout():
	queue_free()
