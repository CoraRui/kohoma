extends Node2D


#TODO: input setup/changing submenu
#TODO: rethink gameplay loop and pause/quit. should quitting at any point always save progress?
#TODO: in what conditions should things save not save? when should quitting be disabled altogether?
#TODO: slow level shift option cause slow slow, and fast hurts.


#this script controls the actual pause menu

#autoloads

@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var pause_li : pause_loader = get_node("/root/pause_loader_auto")

func continue_game():
	pause_li.close_pause_menu()

func quit_game():
	get_tree().quit()

func _on_continue_activated():
	continue_game()

func _on_quit_activated():
	save_fi.record_file(save_fi.file_index)
	quit_game()
