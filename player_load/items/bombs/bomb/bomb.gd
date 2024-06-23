extends Node2D


#four phases:
#init, flash, boom, clear


@export var boom_sf : sf_link

@export var boom_area : Area2D

@export_group("timing")
@export var init_timer : Timer		#time from init to flash
@export var flash_timer : Timer		#timer from flash to explosion
@export var boom_timer : Timer 		#timer from explosion to clear
@export var clear_timer : Timer
@export_group("","")

@export_group("animation")
@export var boom_anim : AnimatedSprite2D
@export var exp_name : String
@export var flash_name : String
@export var idle_name : String
@export_group("","")

func _on_init_timer_timeout():
	boom_anim.play("idle")
	flash_timer.start()

func _on_flash_timer_timeout():
	boom_anim.play("flash")
	boom_timer.start()

func _on_boom_timer_timeout():
	boom_anim.play("boom")
	clear_timer.start()
	#activate_bomb_area
	boom_area.get_child(0).disabled = false

func _on_clear_timer_timeout():
	queue_free()
