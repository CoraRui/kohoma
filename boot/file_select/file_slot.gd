extends Node2D
class_name file_slot

#TODO: add other elements here to display more info in the file select menu

#holds a few ui elements to load from the save file


@export var file_index : int
@export var name_label : Label
@export var text_color : Color
@export var money_label : Label
@export var option_ins : option		#option for relevant file, mostly to connect signal.

@export_group("game_loader parameters?")


#region autoloads

@onready var game_li : game_loader = get_node("")
@onready var save_fi : save_file = get_node("/root/save_file_auto")

#endregion

func _ready():
	refresh_display()
	name_label.add_theme_color_override("font_color", text_color)
	money_label.add_theme_color_override("font_color", text_color)
	
	#connect the file buttons signal to the load game signal in the death trigger.
	if option_ins:
		option_ins.activated.connect(game_li.load_game())
	
func refresh_display():
	if not FileAccess.file_exists(save_fi.save_dir[file_index]):
		return
	var f : file_01 = ResourceLoader.load(save_fi.save_dir[file_index])
	name_label.text = f.player_name
	money_label.text = str(f.gold)
