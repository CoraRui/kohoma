extends Node2D


#attaching this script to an enemy should cause them to unload once the camera begins to shift to 
#the next level, or just once the new level is being loaded. wait. i don't need this. the enemies are attached
#to the world node so that takes care of itself.

#autoloads
@onready var level_bi : level_border = get_node("/root/level_border_auto")
