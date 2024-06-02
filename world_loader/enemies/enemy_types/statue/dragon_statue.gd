extends Node2D

#ok this should be pretty easy. just have the statue shoot a fireball towards(ish) the player every couple seconds or so

#TODO: update sprite. eventually remap all enemy tiles to a single sheet possibly, or at least have a single sheet for an enemy to make it easier to change.


@export_group("shooting")
@export var fire_ref : PackedScene
@export var fire_timer : Timer
@export var autostart : bool = false
@export var delay : float = 7
@export var ran_range : float = 3
@export_group("","")

@export_group("anim")
@export var anim_sprite : AnimatedSprite2D
@export var anim_timer : Timer
@export var anim_delay : float = 0.6
@export var fire_anim_name : String = "nya"
@export_group("","")

func _ready():
	if autostart:
		set_fireball()

func set_fireball():
	var r : float = randf_range(-(ran_range/2), ran_range/2)
	fire_timer.wait_time = delay + r
	fire_timer.start()
	print(delay + r)

func fire():
	set_fireball()
	var new_ball : Node2D = fire_ref.instantiate()
	new_ball.global_position = global_position
	get_tree().get_root().add_child(new_ball)
	anim_sprite.play(fire_anim_name)
	anim_timer.start()
	
func _on_fire_timer_timeout():
	fire()

func _on_anim_del_timeout():
	anim_sprite.play("default")
