extends Node2D
class_name dialogue_box

#TODO: add delay to the reveal of the text arrow
#TODO: add text reveal and sound effects
#TODO: displaying text without clearing old text. mainly to be able to change the style of display midline.
#TODO: some sort of system for timed sound effects.
#TODO: variable in dialogue for adjusting char sfx speed
#TODO: scrolling dialogue??
#TODO: top.bottom of the screen text box


#this script controls the dialogue boxes display functions
#just displays text basically right now, but will eventually add
#voice fx, rolling text, dialogue sprites, other text fx etc.

signal start_write
signal stop_write

#label containing main text
@export var m_label : Label

#label containing name text
@export var n_label : Label

@export var adv_sprite : AnimatedSprite2D

@export var char_sfx : sf_link

var current_text : String
var tf_index : int = 0
var sf_index : int = 0
var char_frames : int = 12
var sf_frames : int = 12
var text_processing : bool = false

@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

func _physics_process(_delta):
	text_process()
	sf_process()

func text_process():
	#skip if there are no more entries in the current text
	if not text_processing:
		return
	
	if current_text.length() <= 0:
		adv_sprite.play("on")
		text_processing = false
		return
		
	#skip displaying text for a certain number of frames
	if tf_index >= char_frames:
		#add text to thing
		m_label.text += current_text[0]
		current_text = current_text.erase(0,1)
		if current_text.length() > 0:
			while(current_text[0] == " "):
				m_label.text += current_text[0]
				current_text = current_text.erase(0,1)
		tf_index = 0
		return
	tf_index += 1

func sf_process():
	#should only play while the string is still displaying
	if current_text.length() <= 0:
		return
		
	if sf_index >= sf_frames:
		sf_index = 0
		sfx_pi.play_sound_link(char_sfx)
	sf_index += 1
	
func display_text(dl : dia_line):
	text_processing = true
	adv_sprite.play("off")
	m_label.text = ""
	char_sfx = dl.char_sf
	char_frames = dl.char_speed
	sf_frames = dl.sf_speed
	current_text = dl.line

