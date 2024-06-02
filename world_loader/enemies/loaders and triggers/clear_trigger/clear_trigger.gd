extends Node2D

#pretty sure the purpose of this was things like having something trigger when all of the enemies in a room
#are defeated. probablyt other uses for something like this too

#this script should hold references to a few enemies.
#when those enemies die, they should signal this script.
#then, this script will check to see how many enemies are left.
#or could I just do it by count?
#I'll just mark this script to fire when a certain number of enemies die. which should be ok if 
#there are only a certain number of enemies in the room.

enum RoomState {DANGER, CLEAR}

var room_state : RoomState = RoomState.DANGER

@export var enemy_cnt : int = 0

signal enemies_cleared

func _ready():
	if enemy_cnt <=0:
		room_state = RoomState.CLEAR

func check_enemies():
	if room_state == RoomState.CLEAR:
		return
	enemy_cnt -= 1
	if enemy_cnt <=0:
		enemies_cleared.emit()

