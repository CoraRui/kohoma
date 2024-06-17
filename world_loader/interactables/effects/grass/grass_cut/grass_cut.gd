extends Node2D

#if its contained to 16 pixels, it looks kinda boring.
#I like the effect they have going with the way the leaves flutter.
#but... who cares? thats for long later.
#TODO: make leaves look cooler

func expire():
	queue_free()

func _on_duration_timer_timeout():
	expire()
