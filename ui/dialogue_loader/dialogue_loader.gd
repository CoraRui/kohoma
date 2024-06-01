extends Node2D
class_name dialogue_loader

#this autoload contains functions for displaying dialogue

#should the dialogue box be instantiated every time?
#I'd say so. wasteful otherwise.

#try to get packed scene to work eventually
@export var dia_box = preload("res://ui/dialogue_loader/dialogue_box.tscn")

var dia_ins : dialogue_box

var current_dialogue : dialogue

var dia_index : int = 0

var dia_active : bool = false

#autoloads

@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

func _process(_delta):
	if not dia_box:
		print("its gone")

func _input(event):
	if not dia_active:
		return
	if event.is_action_pressed("confirm"):
		progress_dialogue()
	
func start_dialogue(d : dialogue):
	dia_active = true
	current_dialogue = d
	dia_ins = dia_box.instantiate()
	add_child(dia_ins)
	progress_dialogue()

func progress_dialogue():
	if dia_index >= current_dialogue.lines.size():
		end_dialogue()
		return
	dia_ins.display_text(current_dialogue.lines[dia_index])
	dia_index += 1
	
func end_dialogue():
	dia_active = false
	current_dialogue = null
	dia_index = 0
	dia_ins.queue_free()
	
	
	
	
	
	
	
	
	
	
	
	
