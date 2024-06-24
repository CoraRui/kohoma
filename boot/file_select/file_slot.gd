extends Node2D
class_name file_slot

#TODO: add other elements here to display more info in the file select menu

#holds a few ui elements to load from the save file


@export var file_index : int
@export var name_label : Label
@export var text_color : Color
@export var money_label : Label

#autoloads

@onready var save_fi : save_file = get_node("/root/save_file_auto")

func _ready():
	refresh_display()
	name_label.add_theme_color_override("font_color", text_color)
	money_label.add_theme_color_override("font_color", text_color)
	
func refresh_display():
	if not FileAccess.file_exists(save_fi.save_dir[file_index]):
		return
	var f : file_01 = ResourceLoader.load(save_fi.save_dir[file_index])
	name_label.text = f.player_name
	money_label.text = str(f.gold)
