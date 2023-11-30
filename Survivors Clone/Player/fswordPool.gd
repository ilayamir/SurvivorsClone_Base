extends Node

var fSwordPool = []
@export var preload_number = 100
var fsword = preload("res://Player/Attack/fswords.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(preload_number):
		var new_fsword = fsword.instantiate()
		add_child(new_fsword)
		fSwordPool.append(new_fsword)
		new_fsword.connect("pool_back", Callable(self,"back_to_pool"))

func back_to_pool(area):
	fSwordPool.append(area)

func draw_from_pool():
	if fSwordPool.size()>0:
		return fSwordPool.pop_back() 
	else:
		var new_fsword = fsword.instantiate()
		add_child(new_fsword)
		new_fsword.connect("pool_back", Callable(self,"back_to_pool"))
		return new_fsword
