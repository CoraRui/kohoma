extends Node2D

#this script controls the orb boss fight

#im not exactly sure how i wanted the fight to go.
#i know theres the boomerang to get the fish.
#and maybe it charges/rolls around?
#the biggest question is how to deal damage
#is it just gonna be a plain hit boss?
#i could do both. maybe plain hits work, but you get a bonus for using the fish.
#like it makes it easier.

#so what aspects does the fight have?

#bomb fish
#bouncy hits

@export var orb_sprite_ins : orb_sprite



func _on_boss_init_area_area_entered(_area):
	#eventually therell be some more substantial kind of intro to the boss battle thing.
	#but right now, the battle just starts the second the player hits touches the area.
	#how do i close the room?
	orb_sprite_ins.init_battle()


