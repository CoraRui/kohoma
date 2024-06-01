extends Node2D
class_name simple_select

#simple select contains options and groups.
#a group holds a variety of options to be navigated between using
#directional keys up down left and right.
#each option may lead to another group being activated.

#currently selected option
@export var active_option : option

#currently selected group
@export var active_group : group

#icon marking currently selected option
@export var icon : Node2D

func _ready():
	icon.global_position = active_option.icon_point.global_position

func _input(event):
	collect_input(event)

func collect_input(e : InputEvent):
	if e.is_action_pressed("confirm"):
		active_option.activate()
		if active_option.target_group:
			switch_group(active_option.target_group)
	if e.is_action_pressed("up"):
		select_this(active_option.up_option)
	if e.is_action_pressed("down"):
		select_this(active_option.down_option)
	if e.is_action_pressed("left"):
		select_this(active_option.left_option)
	if e.is_action_pressed("right"):
		select_this(active_option.right_option)
		
func select_this(no : option):
	if no:
		active_option = no
		icon.global_position = active_option.icon_point.global_position
	
func switch_group(ng : group):
			active_group.set_visible(false)
			active_group = ng
			active_group.set_visible(true)
			select_this(active_group.options[0])
