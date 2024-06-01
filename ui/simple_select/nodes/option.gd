extends Node2D
class_name option


#point for the icon indicating the option
@export var icon_point : Node2D

#group to be switched to on activation. leave blank if not
@export var target_group : group

@export_group("adjacent_options")
@export var up_option : option
@export var down_option : option
@export var left_option : option
@export var right_option : option
@export_group("","")

@export_group("signals")
signal activated
signal selected
signal unselected
@export_group("","")

func _ready():
	#TODO: manually export icon points in file creator
	icon_point = get_child(1)

func activate():
	activated.emit()
