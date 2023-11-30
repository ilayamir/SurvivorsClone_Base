extends Node2D

var mob_array = []
var player_pos = Vector2.ZERO
var enemy_cap = 40

func _ready():
	$TargetUpdate.wait_time = randf_range(0.15,0.25)
	$TargetUpdate.start()

func _on_target_update_timeout():
	for mob in mob_array:
		var wr = weakref(mob)
		if wr.get_ref():
			mob.update_dir(player_pos)
		else:
			mob_array.erase(mob)

func update_loc(pos):
	player_pos = pos
