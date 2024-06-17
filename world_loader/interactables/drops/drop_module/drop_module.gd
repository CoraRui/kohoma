extends Node2D

#this script determines the probability of certain drop types, then drops that item.
#takes into account certain information,for now just the hp value.

@export var heart_drop : PackedScene
@export var coin_drop : PackedScene

@export var heart_base_prob : int = 10
@export var coin_base_prob : int = 10
@export var none_base_prob : int = 80

@export var inh_target : Node2D
@export var pos_target : Node2D

#autoloads
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var world_li : world = get_node("/root/world_auto")

func drop_item():
	var heart_prob : int = heart_base_prob
	var coin_prob : int = coin_base_prob
	var none_prob : int = none_base_prob
	var drop_dict : Dictionary
	
	#if max hp, give heart_prob to coin_prob. if more than 4/5 hp, cut heart prob in half and give to coin.
	if player_li.player_ins.health_script.hp == player_li.player_ins.health_script.mhp:
		coin_prob += heart_prob
		heart_prob = 0
	elif player_li.player_ins.health_script.hp >= (player_li.player_ins.health_script.mhp / 4) * 3:
		coin_prob += heart_prob/2
		heart_prob -= heart_prob/2

	drop_dict["heart"] = heart_prob
	drop_dict["coin"] = coin_prob
	drop_dict["none"] = none_prob

	var result : String = random_generator.random_dict(drop_dict)
	
	match result:
		"heart":
			place_item(heart_drop)
		"coin":
			place_item(coin_drop)
		"none":
			pass
		_:
			print("random generator didn't select a value to drop. why??? D:")
		
func place_item(i : PackedScene):
	var new_drop : Node2D = i.instantiate()
	
	if inh_target:
		inh_target.add_child(new_drop)
	else:
		world_li.current_level.add_child(new_drop)
		
	if pos_target:
		new_drop.global_position = pos_target.global_position
	else:
		new_drop.global_position = global_position
	
func _on_health_death():
	drop_item()
