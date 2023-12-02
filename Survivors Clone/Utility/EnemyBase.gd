extends Node2D
#pool
var pools = {}

func draw_from_pool(type):
	if !pools.has(type):
		pools[type] = []
	if pools[type].size()>0:
		var mob = pools[type].pop_back()
		mob.set_physics_process(true)
		return mob
	else:
		var new_enemy = load(type).instantiate()
		new_enemy.connect("pool_back",Callable(self, "return_to_pool"))
		add_child(new_enemy)
		return new_enemy

func return_to_pool(enemy):
	get_parent().enemies_on_screen-=1
	pools[enemy.scene_file_path].append(enemy)
	enemy.set_physics_process(false)
