extends Node2D
class_name stat_bar


#TODO: key icon
#TODO: flavor text dialogue box
#TODO: flavor text empty state
#TODO: add map?
#TODO: have flavor text appear over ruppees, keys, etc. when called for
#TODO: in dungeon color scheme change


@export var hp_bar : heart_bar

@export var flav : flav_text

@export var key_label : Label

@export var x_item_anim : AnimatedSprite2D

@export var y_item_anim : AnimatedSprite2D

@onready var save_fi : save_file = get_node("/root/save_file_auto")

func _ready():
	update_health(save_fi.current_file.hp, save_fi.current_file.mhp)
	update_key_count()
	set_visible(false)

func update_health(hp, mhp):
	hp_bar.write_hp(hp, mhp)

func update_key_count():
	key_label.text = str(save_fi.current_file.keys)

func update_flav_text(mt : String, nt : String):
	flav.update_text(mt, nt)

func death_reset():
	position = Vector2(0,0)
	#should eventually get health from save file. or the player? no, save file.
	update_health(save_fi.current_file.hp, save_fi.current_file.mhp)

func reset_position():
	global_position = Vector2(0,0)

func update_slot(i : items.ItemState, is_x : bool):
	var anim : AnimatedSprite2D
	if is_x:
		anim = x_item_anim
	else:
		anim = y_item_anim
	match i:
		items.ItemState.BOW:
			anim.play("BOW")
		items.ItemState.BOOMERANG:
			anim.play("BOOMERANG")
		items.ItemState.FISH_ROD:
			anim.play("FISH_ROD")
		items.ItemState.NONE:
			anim.play("NONE")
	
	
	
	
	
	
