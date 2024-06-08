extends Node2D
class_name dialogue_box

#TODO: add text reveal and sound effects
#TODO: displaying text without clearing old text. mainly to be able to change the style of display midline.
#TODO: some sort of system for timed sound effects.
#TODO: variable in dialogue for adjusting char sfx speed


#this script controls the dialogue boxes display functions
#just displays text basically right now, but will eventually add
#voice fx, rolling text, dialogue sprites, other text fx etc.

#label containing main text
@export var m_label : Label

#label containing name text
@export var n_label : Label

@export var adv_sprite : AnimatedSprite2D

@export var char_sfx : String = "default"

var current_text : String
var tf_index : int = 0
var text_frames : int = 12

@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

func _physics_process(_delta):
	text_process()

func text_process():
	#skip if there are no more entries in the current text
	if current_text.length() <= 0:
		return
	#skip displaying text for a certain number of frames
	if tf_index >= text_frames:
		tf_index = 0
		return
	tf_index += 1
	#add text to thing
	m_label.text += current_text[0]
	current_text = current_text.erase(0,1)
	sfx_pi.play_sound(char_sfx)
	

func display_text(l : String):
	m_label.text = ""
	current_text = l

