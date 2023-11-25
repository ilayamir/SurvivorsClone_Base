extends Node2D

@export var spawns: Array[Spawn_info] = []
var enemy_cap = 300
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
	var enemy_spawns = spawns
	var my_children = get_children()
	var direction = player.global_position
	var boss = null
	var hp = 0
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
						enemy_spawn.global_position = get_random_position()
						add_child(enemy_spawn)
						if enemy_spawn.is_in_group("boss"):
							boss = enemy_spawn
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
			new_enemy.global_position = get_random_position()
			add_child(new_enemy)
			if new_enemy.is_in_group("boss"):
				boss = new_enemy
			enemies_to_spawn.remove_at(0)
			leftover_manager.mob_array.append(new_enemy)
			managers.append(leftover_manager)
			counter += 1
	elif time == 298:
		enemies_to_spawn.clear()
	if boss!=null:
		hp = boss.hp
	emit_signal("changetime",time, boss, hp)
	for manager in managers:
		var wr = weakref(manager)
		if wr.get_ref():
			manager.update_loc(direction)
		else:
			managers.erase(manager)
	
func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO

	spawn_pos1 = top_left
	spawn_pos2 = top_right

	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)
