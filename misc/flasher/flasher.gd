extends Node2D
class_name flasher

#this node should have a reference to one or multiple nodes with a set_visible function and turn it on 
#and off at the specified rate

@export var target_nodes : Array[CanvasItem]
@export var init_visible : bool = false		#if true, the flashing starts with the thing invisible
@export var visible_frames : int = 2
@export var invisible_frames : int = 4
@export var flash_timer : Timer
var index : int = 0
var flash_active : bool = false

func _physics_process(_delta):
	if !flash_active:
		return
	
	if target_nodes[0].is_visible() && index >= visible_frames:
		index = 0
		for n in target_nodes:
			n.set_visible(false)
	if !target_nodes[0].is_visible() && index >= invisible_frames:
		index = 0
		for n in target_nodes:
			n.set_visible(true)
	index += 1

func start_flash():
	flash_active = true
	
func stop_flash():
	flash_active = false
	for n in target_nodes:
		n.set_visible(true)

func flash_timed(dur : float):
	#TODO: -1 for use time in node?
	flash_timer.wait_time = dur
	flash_timer.start()
	flash_active = true

func _on_flash_timer_timeout():
	stop_flash()
