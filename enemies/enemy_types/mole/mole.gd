extends Node2D

#this script controls da mole. in general.
#the actual body of the mole is inside this script.



#region inner script exposition

@export_group("stats")
@export var mole_health : enemy_health
@export var hp : int = 10
@export var mhp : int = 10
@export_group("","")

@export_group("mole_movement parameters")
@export var mole_move : mole_movement 
@export var surface_array: Array[Node2D]
@export_group("","")

#endregion

func _ready():
	prepare_inner_parameters()

func prepare_inner_parameters():
	mole_move.surface_array = surface_array
	
	#health
	mole_health.hp = hp
	mole_health.mhp = mhp
	
