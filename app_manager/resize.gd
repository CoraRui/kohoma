extends Node2D


func _ready():
	DisplayServer.window_set_size(Vector2i(704,512))
	
func _input(event):
	if event.is_action_pressed("app_resize"):
		if get_window().mode == Window.MODE_WINDOWED:
			get_window().mode = Window.MODE_FULLSCREEN
		else:
			get_window().mode = Window.MODE_WINDOWED
	
