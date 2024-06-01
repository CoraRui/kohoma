extends Node2D


#handles quitting and screen sizing

@export_group("quit_timing")
@export var quit_timer : Timer
@export var quit_text : Label
@export_group("","")


func _input(event):
	if event.is_action_pressed("app_quit"):
		quit_timer.start()
		quit_text.set_visible(true)
	if event.is_action_released("app_quit"):
		quit_timer.stop()
		quit_text.set_visible(false)
		
func _on_quit_timer_timeout():
	get_tree().quit()
