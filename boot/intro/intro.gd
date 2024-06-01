extends Node2D


#handles the intro stuff.
#I'm thinking basic basic. like just put the image up, maybe some movement,
#and darkening between switches. but for now:
#timing for certain changes


@export_group("timing")
@export var txt_del_arr : Array[float]
@export_multiline var txt_arr : Array[String]
var txt_index : int = 0
@export var img_del_arr : Array[float]
@export var img_arr : Array[String]
var img_index : int = 0
@export var txt_del : Timer
@export var img_del : Timer
@export_group("","")

@export var mural_anim : AnimatedSprite2D
@export var d_box : dialogue_box

func _ready():
	txt_del.wait_time = txt_del_arr[0]
	img_del.wait_time = img_del_arr[0]
	txt_del.start()
	img_del.start()
	mural_anim.play(img_arr[img_index])
	d_box.display_text(txt_arr[txt_index])
	txt_index += 1
	img_index += 1

func _on_img_del_timeout():
	#should update the image and restart the timer with the next time amount
	img_del.wait_time = img_del_arr[img_index]
	img_del.start()
	mural_anim.play(img_arr[img_index])
	img_index += 1
	
func _on_txt_del_timeout():
		#should update the image and restart the timer with the next time amount
	txt_del.wait_time = txt_del_arr[txt_index]
	txt_del.start()
	d_box.display_text(txt_arr[txt_index])
	txt_index += 1 
