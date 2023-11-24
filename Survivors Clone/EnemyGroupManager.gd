extends Node2D

var mob_array = []
var player_pos = Vector2.ZERO

func _on_target_update_timeout():
	for mob in mob_array:
		var wr = weakref(mob)
		if wr.get_ref():
			mob.update_dir(player_pos)
		else:
			mob_array.erase(mob)


func _on_empty_check_timeout():
	if mob_array.size() == 0:
		queue_free()

func update_loc(pos):
	player_pos = pos
