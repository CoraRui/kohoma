extends Node2D

func expire():
	queue_free()

func _on_duration_timer_timeout():
	expire()
