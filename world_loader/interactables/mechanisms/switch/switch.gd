extends Node2D

#TODO: enable activation by various things


#region node refs
@export_group("node refs")
@export var switch_anim : AnimatedSprite2D
@export var switch_timer : Timer			#delay between switch flips. so it doesn't switch really fast
@export_group("","")
#endregion

#region sfx
@export_group("sfx")
@export var switch_on_sf : sf_link
@export var switch_off_sf : sf_link
@export_group("","")
#endregion

#region signals
signal switch_on		#fires when turned on
signal switch_off		#fires when turned off
#endregion

#region switch parameters
@export_group("switch parameters")
@export var switch_active : bool = false : 
	get:
		return switch_active
	set(v):
		#play correct animation on start
		if !is_node_ready():
			await ready
		match v:
			true:
				switch_anim.play("on")
			false:
				switch_anim.play("off")
		switch_active = v
@export_group("","")
#endregion

@export var debug_name : String

#internals
var delay_active : bool = false		#activated after each flip to prevent fast switching

#region autoloads
#autoloads
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var debug_hi : debug_helper = get_node("/root/debug_helper_auto")
#endregion

func _ready():
	init_stuff()

func init_stuff():
	pass

func flip():
	if delay_active:
		return
		
	print("*click*")
	#animate
	match switch_active:
		true:
			switch_anim.play("off")
			switch_off.emit()
			sfx_pi.play_sound_link(switch_off_sf)
		false:
			switch_anim.play("on")
			switch_on.emit()
			sfx_pi.play_sound_link(switch_on_sf)
	
	#flip value
	switch_active = !switch_active
	switch_timer.start()
	delay_active = true

func _on_switch_area_area_entered(_area):
	flip()

func _on_switch_timer_timeout():
	delay_active = false

