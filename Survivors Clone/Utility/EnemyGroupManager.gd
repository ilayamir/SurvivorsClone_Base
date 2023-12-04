extends Node2D

var mob_array = []
var player_pos = Vector2.ZERO
var enemy_cap = 40
var physic_proccessing_index = 0

func _ready():
	$TargetUpdate.wait_time = randf_range(0.15,0.25)
	$TargetUpdate.start()

		
func _on_target_update_timeout():
	for mob in mob_array:
		var wr = weakref(mob)
		if wr.get_ref(): #!mob.disabled:
			mob.update_dir(player_pos)
		else:
			mob_array.erase(mob)

func update_loc(pos):
	player_pos = pos

func remove(object):
	if mob_array.has(object):
		object.disconnect("remove_from_array", Callable(self,"remove"))
		mob_array.erase(object)
