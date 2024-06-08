extends Node2D
class_name dialogue_loader

#TODO: load the dialogue box in the correct spot, probably related to the world loaders current worlds position
#TODO: figure out correct place in draw order

#this autoload is loads in and out the dialogue box and handles the input for progressing the dialogue.
#are probably a variety of things that will use it.

#signals
signal dialogue_end
signal dialogue_advance

#dialogue_ref
@export var dia_box = preload("res://ui/dialogue_loader/dialogue_box.tscn")

#internal variables
var dia_ins : dialogue_box
var current_dialogue : dialogue
var dia_index : int = 0
var dia_active : bool = false

#autoloads
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var world_li : world = get_node("/root/world_auto")

func _input(event):
	if not dia_active:
		return
	if event.is_action_pressed("confirm"):
		progress_dialogue()
	
func start_dialogue(d : dialogue):
	if dia_active:
		end_dialogue()
	dia_active = true
	current_dialogue = d
	dia_ins = dia_box.instantiate()
	add_child(dia_ins)
	dia_ins.global_position = world_li.current_level.global_position
	progress_dialogue()

func progress_dialogue():
	dialogue_advance.emit()
	if dia_index >= current_dialogue.lines.size():
		end_dialogue()
		return
	dia_ins.display_text(current_dialogue.lines[dia_index])
	dia_index += 1
	
func end_dialogue():
	dialogue_end.emit()
	dia_active = false
	current_dialogue = null
	dia_index = 0
	dia_ins.queue_free()
	
	
	
	
	
	
	
	
	
	
	
	
