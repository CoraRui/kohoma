extends Node2D

#TODO: this isn't super necessary but maybe add some sort of delay to enemies spawning. like the little clouds in legend of zelda.
#TODO: work on the random generation of the enemies spawn location
#TODO: make sure that queueing the spawner free after spawning stuff is actually ok, although im sure its fine.
#TODO: spawn the enemies far enough from the player so they dont spawn on them, or just use the clouds to give the player time to move away.

@export_group("rng")
@export var enemy_arr : Array[enemy_slot]
#how many enemies to spawn total
@export var enemy_cnt : int = 3
#how much the enemy cnt varies
@export var enemy_var : int = 1
#locations for enemy spawn
@export var spawn_pos : Array[Node2D]

#autoloads:
@onready var camera_li : camera_loader = get_node("/root/camera_loader_auto")
@onready var world_loader : world = get_node("/root/world_auto")

func _ready():
	camera_li.camera_snapped.connect(spawn_enemies)

func spawn_enemies():
	#ok so:
	#the for loop adds up all of the spawn chances to get the total
	#the first while loop runs the spawn function however many times to spawn the right number of enemies
	#the second while loop runs code to determine probability to spawn each enemy
	var i = 0
	var tot : int = 0
	
	#total spawn_chance
	for e in enemy_arr:
		tot += e.spawn_chance
	
	#spawn enemy_cnt of enemies
	while i < enemy_cnt:
		#rolls a value using the total value of all of the spawn chances.
		var roll : int = randi_range(0, tot)
		print(roll, tot)
		#subtract the spawn chance of each enemy from the roll. if the roll is less than or equal to 0, that means that
		#the roll was in the current enemies range. so, when the while loop breaks, i2 will be the enemy to spawn
		var i2 : int = 0
		while roll > 0 && i2 < enemy_arr.size():
			roll -= enemy_arr[i2].spawn_chance
			if roll <= 0:
				break
			i2 += 1
		#now i2 should be the index of the enemy to spawn.
		if enemy_arr.size() == 0:
			print("theres an empty enemy spawner.")
			return
		if not enemy_arr[i2]:
			print("couldn't find enemy ref in index", i2, "of", name)
			return
		var new_enemy = enemy_arr[i2].enemy_ref.instantiate()
		new_enemy.position = spawn_pos[randi_range(0, spawn_pos.size()-1)].position
		world_loader.current_level.add_child(new_enemy)

		i += 1
		queue_free()
		
