extends Enemy

func extra_ready_stuff():
	if !disabled:
		if direction.x > 0.1:
			sprite.flip_h = true
			if !dead: anim.play("walk_right")
		elif direction.x < -0.1:
			sprite.flip_h = false
			if !dead: anim.play("walk")

func _on_get_dir_timer_timeout():
	if !disabled:
		direction = global_position.direction_to(curr_player_pos).normalized()
		if direction.x >= 0:
			sprite.flip_h = true
			if !dead: anim.play("walk_right")
		elif direction.x < 0:
			sprite.flip_h = false
			if !dead: anim.play("walk")
