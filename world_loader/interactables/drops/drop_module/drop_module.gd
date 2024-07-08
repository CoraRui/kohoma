extends Node2D

#this node contains a couple different options for drops.
#has a couple packedscenes whose probability to spawn on drop are defined in probability parameters
#should be attached to certain enemies to have those enemies drop specific things.

#region drop_objects

@export_group("drop_objects")
@export var heart_drop : PackedScene
@export var coin_drop : PackedScene
@export_group("","")

#endregion

#region probability parameters

@export_group("probablility parameters")
@export var heart_base_prob : int = 10
@export var coin_base_prob : int = 10
@export var none_base_prob : int = 80
@export_group("","")

#endregion

#region node_refs

@export_group("node refs")
@export var inh_target : Node2D
@export var pos_target : Node2D
@export_group("","")

#endregion

#region autoloads

@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var world_li : world = get_node("/root/world_auto")

#endregion

#region instantiation/removal functions

func drop_item() -> void:
	#main function. calculates which item to drop, then calls the place function with the appropriate parameter.
	
	var heart_prob : int = heart_base_prob
	var coin_prob : int = coin_base_prob
	var none_prob : int = none_base_prob
	var drop_dict : Dictionary = {}
	
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

func place_item(i : PackedScene) -> void:
	#places the item at the specified location.
	var new_drop : Node2D = i.instantiate()
	
	if inh_target:
		inh_target.add_child(new_drop)
	else:
		world_li.current_level.add_child(new_drop)
		
	if pos_target:
		new_drop.global_position = pos_target.global_position
	else:
		new_drop.global_position = global_position

func destroy_item() -> void:
	#frees the item. mostly for expiration.
	queue_free()

#endregion

#region signal in

func _on_health_death():
	#death of enemy signal. drops the item when the enemy dies.
	drop_item()

func _on_drop_timer_timeout():
	#expiratoin signal. destroys the item.
	destroy_item()

#endregion
