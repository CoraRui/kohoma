extends Node2D
class_name heart_bar

@export var heart_arr : Array[Sprite2D]

@export var heart_txt : Array[Texture2D]


func write_hp(hp : int, mhp : int):
	var i : int = 0
	while i < hp / 4:
		heart_arr[i].texture = heart_txt[4]
		i += 1
	if hp%4 != 0:
		heart_arr[hp/4].texture = heart_txt[hp%4]
		i += 1
	while i < mhp/4:
		heart_arr[i].texture = heart_txt[0]
		i += 1
	while i < heart_arr.size():
		heart_arr[i].texture = heart_txt[5]
		i+= 1

