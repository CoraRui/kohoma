extends Node2D
class_name dialogue_box

#this script controls the dialogue boxes display functions
#just displays text basically right now, but will eventually add
#voice fx, rolling text, dialogue sprites, other text fx etc.

#label containing main text
@export var m_label : Label

#label containing name text
@export var n_label : Label

func display_text(l : String):
	m_label.text = l

