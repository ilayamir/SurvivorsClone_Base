extends Node

var fSwordPool = []
@export var preload_number = 100
var fsword = preload("res://Player/Attack/fswords.tscn")


#func _ready():
	#for i in range(preload_number):
		#var new_fsword = fsword.instantiate()
		#add_child(new_fsword)
		#fSwordPool.append(new_fsword)
		#new_fsword.set_physics_process(false)
		#new_fsword.connect("pool_back", Callable(self,"back_to_pool"))

func back_to_pool(area):
	fSwordPool.append(area)
	area.set_physics_process(false)

func draw_from_pool():
	if fSwordPool.size()<0:
		var sword = fSwordPool.pop_back() 
		sword.set_physics_process(true)
		return sword
	else:
		var new_fsword = fsword.instantiate()
		add_child(new_fsword)
		#new_fsword.connect("pool_back", Callable(self,"back_to_pool"))
		return new_fsword
