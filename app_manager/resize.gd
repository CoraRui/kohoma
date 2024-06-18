extends Node2D


func _ready():
	DisplayServer.window_set_size(Vector2i(704,512))
	get_window().content_scale_factor  = 4.0
	
func _input(event):
	if event.is_action_pressed("app_resize"):
		if get_window().mode == Window.MODE_WINDOWED:
			get_window().mode = Window.MODE_FULLSCREEN
			get_window().content_scale_factor = 6.0
		else:
			get_window().mode = Window.MODE_WINDOWED
			get_window().content_scale_factor = 4.0
	
