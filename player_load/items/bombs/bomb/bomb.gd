extends Node2D


#four phases:
#init, flash, boom, clear

#do i want a wall? i dont even know that i want the bombs to be throwable.
#so i dont think it needs it. its just the fish that needs it cause its thrown.
#and pots in general. cause they have to be thrown

#TODO: i need some sort of protocol for what happens to the player lift state when carrying a fishbomb that explodes.
#added signals so that i can link the player lifts change in state to the clear signal.

@export var boom_sf : sf_link

@export var boom_area : Area2D

@export var auto_light : bool = true

@export var bomb_target : Node2D			#connect to a node to destroy on clear or boom?

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

#signals
signal init_signal
signal flash_signal
signal boom_signal
signal clear_signal

func _ready():
	if auto_light:
		init_start()
	boom_anim.play(idle_name)

func init_start() -> void:
	boom_anim.play(idle_name)
	flash_timer.start()
	init_signal.emit()

func flash_start() -> void:
	boom_anim.play(flash_name)
	boom_timer.start()
	flash_signal.emit()

func boom_start() -> void:
	boom_anim.play(exp_name)
	clear_timer.start()
	#activate_bomb_area
	boom_area.get_child(0).disabled = false
	boom_signal.emit()

func clear() -> void:
	clear_signal.emit()
	if bomb_target:
		bomb_target.queue_free()
	queue_free()
	

func _on_init_timer_timeout():
	init_start()

func _on_flash_timer_timeout():
	flash_start()

func _on_boom_timer_timeout():
	boom_start()

func _on_clear_timer_timeout():
	clear()

func _on_catch_released():
	#from the catch nodes released signal. that signal should be connected to the catch points signal in the boomerang.
	#so when the boomerang is released, this should fire. meaning that the fish should start detonating
	if !init_timer.paused:
		print("init start")
		init_start()
