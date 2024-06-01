extends Node2D
class_name dialogue_box

#TODO: add text reveal and sound effects
#TODO: displaying text without clearing old text. mainly to be able to change the style of display midline.
#TODO: some sort of system for timed sound effects.


#this script controls the dialogue boxes display functions
#just displays text basically right now, but will eventually add
#voice fx, rolling text, dialogue sprites, other text fx etc.

#label containing main text
@export var m_label : Label

#label containing name text
@export var n_label : Label

func display_text(l : String):
	m_label.text = l

