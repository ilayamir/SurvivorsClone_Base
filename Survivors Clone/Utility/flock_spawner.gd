extends Node2D

@export var spawns: Array[Spawn_info] = []
var enemy_cap = 400
var enemies_to_spawn = []
var managers = []

@onready var player = get_tree().get_first_node_in_group("player")
var group_manager = preload("res://Utility/enemy_group_manager.tscn")

@export var time = 238
signal changetime(time)

func _ready():
	connect("changetime",Callable(player,"change_time"))

func _on_timer_timeout():
	time += 1
	var corner=randi_range(0,1)
	var enemy_spawns = spawns
	var my_children = get_children()
	var direction = player.global_position
	for i in enemy_spawns:
		var i_manager = group_manager.instantiate()
		add_child(i_manager)
		i_manager.update_loc(direction)
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter <= i.enemy_num:
					if my_children.size() <= enemy_cap:
						var enemy_spawn = new_enemy.instantiate()
						enemy_spawn.global_position = get_random_position(corner)
						enemy_spawn.in_flock = true
						enemy_spawn.top_right = corner
						add_child(enemy_spawn)
						i_manager.mob_array.append(enemy_spawn)
						managers.append(i_manager)
					else:
						enemies_to_spawn.append(new_enemy)
					counter += 1
	if my_children.size()<= enemy_cap and enemies_to_spawn.size()<=enemy_cap and time<300:
		var spawn_number = clamp(enemies_to_spawn.size(), 1, 50) - 1
		var counter = 0
		while counter < spawn_number:
			var leftover_manager = group_manager.instantiate()
			leftover_manager.update_loc(direction)
			add_child(leftover_manager)
			var new_enemy = enemies_to_spawn[0].instantiate()
			corner = randi_range(0,1)
			new_enemy.global_position = get_random_position(corner)
			new_enemy.in_flock = true
			new_enemy.top_right = corner
			add_child(new_enemy)
			enemies_to_spawn.remove_at(0)
			leftover_manager.mob_array.append(new_enemy)
			managers.append(leftover_manager)
			counter += 1
	elif time == 298:
		enemies_to_spawn.clear()
	emit_signal("changetime",time)
	for manager in managers:
		var wr = weakref(manager)
		if wr.get_ref():
			manager.update_loc(direction)
		else:
			managers.erase(manager)
	if time == 299:
		get_tree().call_group("enemy", "death")
	

func get_random_position(corner):
	var vpr = get_viewport_rect().size
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var spawn_pos = Vector2.ZERO
	
	match corner:
		0: #right
			spawn_pos = top_right
		1: #left
			spawn_pos = top_left
	
	var x_spawn = randf_range(spawn_pos.x-30, spawn_pos.x+30)
	var y_spawn = randf_range(spawn_pos.y-30,spawn_pos.y+30)
	
	return Vector2(x_spawn,y_spawn)
