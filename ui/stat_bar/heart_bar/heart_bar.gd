extends Node2D
class_name heart_bar

@export var heart_arr : Array[AnimatedSprite2D]

@export var heart_txt : Array[Texture2D]


func write_hp(hp : int, mhp : int):
	var i : int = 0
	while i < hp / 4:
		
		heart_arr[i].play(get_anim_name(4))
		i += 1
	if hp%4 != 0:
		heart_arr[hp/4].play(get_anim_name(hp%4))
		i += 1
	while i < mhp/4:
		heart_arr[i].play(get_anim_name(0))
		i += 1
	while i < heart_arr.size():
		heart_arr[i].play(get_anim_name(5))
		i+= 1

func get_anim_name(i : int) -> String:
	match i:
		0:
			return "04"
		1:
			return "14"
		2:
			return "24"
		3:
			return "34"
		4:
			return "44"
		5:
			return "no_heart"
		_:
			print("heart_anim has weird value")
			return "04"
			
	
	
	
	
