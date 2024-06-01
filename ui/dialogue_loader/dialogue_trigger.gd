extends Node2D


#this script should contain a dialogue and send that to the dialogue autoload when triggered

@export var dia : dialogue

#autoloads
@onready var dialogue_li : dialogue_loader = get_node("/root/dialogue_loader_auto")


func start_dialogue():
	dialogue_li.start_dialogue(dia)
	


func _on_d_area_area_entered(_area):
	start_dialogue()
