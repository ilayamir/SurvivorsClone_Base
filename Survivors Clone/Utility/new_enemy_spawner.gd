extends Node2D

### Assertions:
#each wave starts when the previous ends
#chance.size == enemy.size AND chance[-1] == 100 AND chance is ordered lowest to highest AND every num in chance is positive

@export var spawns: Array[New_spawn_info] = []
var enemy_cap = 300
var enemies_to_spawn = []
var managers = []
var end_time = 0
var current_wave = []
var current_wave_rates = []
var current_wave_minimum = 0
var current_wave_end = 0
var direction = Vector2.ZERO
@export var preload_manager_count = 8

@onready var player = get_tree().get_first_node_in_group("player")
var group_manager = preload("res://Utility/enemy_group_manager.tscn")

@export var time = 0
signal changetime(time)

func _ready():
	connect("changetime",Callable(player,"change_time"))
	end_time = player.end_time
	for i in range(preload_manager_count):
		var manager = group_manager.instantiate()
		$ManagerBase.add_child(manager)
		manager.update_loc(direction)
		managers.append(manager)

func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.05,1.15)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)

func _on_global_timer_timeout():
	time+=1
	direction = player.global_position
	emit_signal("changetime",time)
	for wave in spawns:
		if wave.time_start<=time and wave.time_end>time:
			$SpawnRateTimer.wait_time = wave.enemy_spawn_rate
			current_wave = wave.enemy
			current_wave_rates = wave.enemy_chance
			current_wave_minimum = wave.enemy_minimum
			current_wave_end = wave.time_end
			$SpawnRateTimer.start()
			spawns.pop_front()
	if current_wave_end<time:
		$SpawnRateTimer.stop()
	for manager in managers:
		var wr = weakref(manager)
		if wr.get_ref():
			manager.update_loc(direction)
		else:
			managers.erase(manager)
	if time == end_time-5:
		get_tree().call_group("enemy", "death")
		$SpawnRateTimer.stop()



func _on_spawn_rate_timer_timeout():
	var enemies_alive = $EnemyBase.get_child_count()
	var manager = get_manager()
	if manager == null:
		manager = group_manager.instantiate()
		$ManagerBase.add_child(manager)
		manager.update_loc(direction)
		managers.append(manager)

	if enemies_alive<current_wave_minimum:
		for i in range(1, current_wave_minimum-enemies_alive+1):
			var enemy_spawn = get_enemy().instantiate()
			enemy_spawn.global_position = get_random_position()
			$EnemyBase.add_child(enemy_spawn)
			manager.mob_array.append(enemy_spawn)

	elif enemies_alive<enemy_cap:
		var enemy_spawn = get_enemy().instantiate()
		enemy_spawn.global_position = get_random_position()
		$EnemyBase.add_child(enemy_spawn)
		manager.mob_array.append(enemy_spawn)

func get_enemy():
	var choose = randi_range(1,100)
	var option_cnt = current_wave_rates.size()
	for i in range(0, option_cnt):
		if choose <= current_wave_rates[i]:
			return current_wave[i]

func get_manager():
	var manager = null
	if $ManagerBase.get_child_count() > 0:
		var manager_group = $ManagerBase.get_children()
		for manager_opt in manager_group:
			if manager_opt.mob_array.size() <= manager_opt.enemy_cap:
				return manager_opt
	return manager
