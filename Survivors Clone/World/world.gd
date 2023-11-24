extends Node2D

@onready var bgd_grid  = {"center":get_child(0), "right":get_child(1), "downright":get_child(2), "down":get_child(3), "left":get_child(4), "downleft":get_child(5), "upright":get_child(6), "up":get_child(7), "upleft":get_child(8)}
var bckgrnd = preload("res://World/background.tscn")

func _ready():
	pass

func _on_background_down(item):
	var new_bgd_down = bckgrnd.instantiate()
	var new_bgd_downleft = bckgrnd.instantiate()
	var new_bgd_downright = bckgrnd.instantiate()
	
	new_bgd_down.global_position.y = item.global_position.y + 2160
	new_bgd_down.global_position.x = item.global_position.x
	new_bgd_downleft.global_position.y = item.global_position.y + 2160
	new_bgd_downleft.global_position.x = item.global_position.x - 1920
	new_bgd_downright.global_position.y = item.global_position.y + 2160
	new_bgd_downright.global_position.x = item.global_position.x + 1920
	
	item.get_parent().add_child(new_bgd_down)
	item.get_parent().add_child(new_bgd_downleft)
	item.get_parent().add_child(new_bgd_downright)
	
	new_bgd_down.connect("down", Callable(new_bgd_down.get_parent(),"_on_background_down"))
	new_bgd_down.connect("up", Callable(new_bgd_down.get_parent(),"_on_background_up"))
	new_bgd_down.connect("left", Callable(new_bgd_down.get_parent(),"_on_background_left"))
	new_bgd_down.connect("right", Callable(new_bgd_down.get_parent(),"_on_background_right"))
	
	new_bgd_downleft.connect("down", Callable(new_bgd_downleft.get_parent(),"_on_background_down"))
	new_bgd_downleft.connect("up", Callable(new_bgd_downleft.get_parent(),"_on_background_up"))
	new_bgd_downleft.connect("left", Callable(new_bgd_downleft.get_parent(),"_on_background_left"))
	new_bgd_downleft.connect("right", Callable(new_bgd_downright.get_parent(),"_on_background_right"))
	
	new_bgd_downright.connect("down", Callable(new_bgd_downright.get_parent(),"_on_background_down"))
	new_bgd_downright.connect("up", Callable(new_bgd_downright.get_parent(),"_on_background_up"))
	new_bgd_downright.connect("left", Callable(new_bgd_downright.get_parent(),"_on_background_left"))
	new_bgd_downright.connect("right", Callable(new_bgd_downright.get_parent(),"_on_background_right"))
	
	new_bgd_down.get_parent().move_child(new_bgd_down, 0)
	new_bgd_downleft.get_parent().move_child(new_bgd_downleft, 0)
	new_bgd_downright.get_parent().move_child(new_bgd_downright, 0)
	
	var old_up = bgd_grid["up"]
	var old_upright = bgd_grid["upright"]
	var old_upleft = bgd_grid["upleft"]
	
	bgd_grid["up"] = bgd_grid.get("center")
	bgd_grid["upright"] = bgd_grid.get("right")
	bgd_grid["upleft"] = bgd_grid.get("left")
	bgd_grid["center"] = bgd_grid.get("down")
	bgd_grid["right"] = bgd_grid.get("downright")
	bgd_grid["left"] = bgd_grid.get("downleft")
	bgd_grid["down"] = new_bgd_down
	bgd_grid["downright"] = new_bgd_downright
	bgd_grid["downleft"] = new_bgd_downleft
	
	old_up.queue_free()
	old_upright.queue_free()
	old_upleft.queue_free()

func _on_background_left(item):
	var new_bgd_left = bckgrnd.instantiate()
	var new_bgd_downleft = bckgrnd.instantiate()
	var new_bgd_upleft = bckgrnd.instantiate()

	new_bgd_left.global_position.y = item.global_position.y
	new_bgd_left.global_position.x = item.global_position.x - 3840
	new_bgd_downleft.global_position.y = item.global_position.y + 1080
	new_bgd_downleft.global_position.x = item.global_position.x - 3840
	new_bgd_upleft.global_position.y = item.global_position.y - 1080
	new_bgd_upleft.global_position.x = item.global_position.x - 3840

	item.get_parent().add_child(new_bgd_left)
	item.get_parent().add_child(new_bgd_downleft)
	item.get_parent().add_child(new_bgd_upleft)

	new_bgd_left.connect("down", Callable(new_bgd_left.get_parent(),"_on_background_down"))
	new_bgd_left.connect("up", Callable(new_bgd_left.get_parent(),"_on_background_up"))
	new_bgd_left.connect("left", Callable(new_bgd_left.get_parent(),"_on_background_left"))
	new_bgd_left.connect("right", Callable(new_bgd_left.get_parent(),"_on_background_right"))

	new_bgd_downleft.connect("down", Callable(new_bgd_downleft.get_parent(),"_on_background_down"))
	new_bgd_downleft.connect("up", Callable(new_bgd_downleft.get_parent(),"_on_background_up"))
	new_bgd_downleft.connect("left", Callable(new_bgd_downleft.get_parent(),"_on_background_left"))
	new_bgd_downleft.connect("right", Callable(new_bgd_downleft.get_parent(),"_on_background_right"))

	new_bgd_upleft.connect("down", Callable(new_bgd_upleft.get_parent(),"_on_background_down"))
	new_bgd_upleft.connect("up", Callable(new_bgd_upleft.get_parent(),"_on_background_up"))
	new_bgd_upleft.connect("left", Callable(new_bgd_upleft.get_parent(),"_on_background_left"))
	new_bgd_upleft.connect("right", Callable(new_bgd_upleft.get_parent(),"_on_background_right"))

	new_bgd_left.get_parent().move_child(new_bgd_left, 0)
	new_bgd_downleft.get_parent().move_child(new_bgd_downleft, 0)
	new_bgd_upleft.get_parent().move_child(new_bgd_upleft, 0)

	var old_right = bgd_grid.get("right")
	var old_upright = bgd_grid.get("upright")
	var old_downright = bgd_grid.get("downright")

	bgd_grid["right"] = bgd_grid.get("center")
	bgd_grid["upright"] = bgd_grid.get("up")
	bgd_grid["up"] = bgd_grid.get("upleft")
	bgd_grid["upleft"] = new_bgd_upleft
	bgd_grid["center"] = bgd_grid.get("left")
	bgd_grid["downright"] = bgd_grid.get("down")
	bgd_grid["left"] = new_bgd_left
	bgd_grid["down"] = bgd_grid.get("downleft")
	bgd_grid["downleft"] = new_bgd_downleft

	old_right.queue_free()
	old_upright.queue_free()
	old_downright.queue_free()

func _on_background_right(item):
	var new_bgd_right = bckgrnd.instantiate()
	var new_bgd_downright = bckgrnd.instantiate()
	var new_bgd_upright = bckgrnd.instantiate()

	new_bgd_right.global_position.y = item.global_position.y
	new_bgd_right.global_position.x = item.global_position.x + 3840
	new_bgd_downright.global_position.y = item.global_position.y + 1080
	new_bgd_downright.global_position.x = item.global_position.x + 3840
	new_bgd_upright.global_position.y = item.global_position.y - 1080
	new_bgd_upright.global_position.x = item.global_position.x + 3840

	item.get_parent().add_child(new_bgd_right)
	item.get_parent().add_child(new_bgd_downright)
	item.get_parent().add_child(new_bgd_upright)

	new_bgd_right.connect("down", Callable(new_bgd_right.get_parent(),"_on_background_down"))
	new_bgd_right.connect("up", Callable(new_bgd_right.get_parent(),"_on_background_up"))
	new_bgd_right.connect("left", Callable(new_bgd_right.get_parent(),"_on_background_left"))
	new_bgd_right.connect("right", Callable(new_bgd_right.get_parent(),"_on_background_right"))

	new_bgd_downright.connect("down", Callable(new_bgd_downright.get_parent(),"_on_background_down"))
	new_bgd_downright.connect("up", Callable(new_bgd_downright.get_parent(),"_on_background_up"))
	new_bgd_downright.connect("left", Callable(new_bgd_downright.get_parent(),"_on_background_left"))
	new_bgd_downright.connect("right", Callable(new_bgd_downright.get_parent(),"_on_background_right"))

	new_bgd_upright.connect("down", Callable(new_bgd_upright.get_parent(),"_on_background_down"))
	new_bgd_upright.connect("up", Callable(new_bgd_upright.get_parent(),"_on_background_up"))
	new_bgd_upright.connect("left", Callable(new_bgd_upright.get_parent(),"_on_background_left"))
	new_bgd_upright.connect("right", Callable(new_bgd_upright.get_parent(),"_on_background_right"))

	new_bgd_right.get_parent().move_child(new_bgd_right, 0)
	new_bgd_downright.get_parent().move_child(new_bgd_downright, 0)
	new_bgd_upright.get_parent().move_child(new_bgd_upright, 0)

	var old_left = bgd_grid.get("left")
	var old_uprleft = bgd_grid.get("upleft")
	var old_downleft = bgd_grid.get("downleft")

	bgd_grid["upleft"] = bgd_grid.get("up")
	bgd_grid["up"] = bgd_grid.get("upright")
	bgd_grid["left"] = bgd_grid.get("center")
	bgd_grid["center"] = bgd_grid.get("right")
	bgd_grid["downleft"] = bgd_grid.get("down")
	bgd_grid["down"] = bgd_grid.get("downright")
	bgd_grid["right"] = new_bgd_right
	bgd_grid["upright"] = new_bgd_upright
	bgd_grid["downright"] = new_bgd_downright

	old_left.queue_free()
	old_uprleft.queue_free()
	old_downleft.queue_free()

func _on_background_up(item):
	var new_bgd_up = bckgrnd.instantiate()
	var new_bgd_upleft = bckgrnd.instantiate()
	var new_bgd_upright = bckgrnd.instantiate()
	
	new_bgd_up.global_position.y = item.global_position.y - 2160
	new_bgd_up.global_position.x = item.global_position.x
	new_bgd_upleft.global_position.y = item.global_position.y - 2160
	new_bgd_upleft.global_position.x = item.global_position.x - 1920
	new_bgd_upright.global_position.y = item.global_position.y - 2160
	new_bgd_upright.global_position.x = item.global_position.x + 1920
	
	item.get_parent().add_child(new_bgd_up)
	item.get_parent().add_child(new_bgd_upleft)
	item.get_parent().add_child(new_bgd_upright)
	
	new_bgd_up.connect("down", Callable(new_bgd_up.get_parent(),"_on_background_down"))
	new_bgd_up.connect("up", Callable(new_bgd_up.get_parent(),"_on_background_up"))
	new_bgd_up.connect("left", Callable(new_bgd_up.get_parent(),"_on_background_left"))
	new_bgd_up.connect("right", Callable(new_bgd_up.get_parent(),"_on_background_right"))
	
	new_bgd_upleft.connect("down", Callable(new_bgd_upleft.get_parent(),"_on_background_down"))
	new_bgd_upleft.connect("up", Callable(new_bgd_upleft.get_parent(),"_on_background_up"))
	new_bgd_upleft.connect("left", Callable(new_bgd_upleft.get_parent(),"_on_background_left"))
	new_bgd_upleft.connect("right", Callable(new_bgd_upleft.get_parent(),"_on_background_right"))
	
	new_bgd_upright.connect("down", Callable(new_bgd_upright.get_parent(),"_on_background_down"))
	new_bgd_upright.connect("up", Callable(new_bgd_upright.get_parent(),"_on_background_up"))
	new_bgd_upright.connect("left", Callable(new_bgd_upright.get_parent(),"_on_background_left"))
	new_bgd_upright.connect("right", Callable(new_bgd_upright.get_parent(),"_on_background_right"))
	
	new_bgd_up.get_parent().move_child(new_bgd_up, 0)
	new_bgd_upleft.get_parent().move_child(new_bgd_upleft, 0)
	new_bgd_upright.get_parent().move_child(new_bgd_upright, 0)
	
	var old_down = bgd_grid["down"]
	var old_downright = bgd_grid["downright"]
	var old_downleft = bgd_grid["downleft"]
	
	bgd_grid["down"] = bgd_grid.get("center")
	bgd_grid["center"] = bgd_grid.get("up")
	bgd_grid["downright"] = bgd_grid.get("right")
	bgd_grid["right"] = bgd_grid.get("upright")
	bgd_grid["downleft"] = bgd_grid.get("left")
	bgd_grid["left"] = bgd_grid.get("upleft")
	bgd_grid["up"] = new_bgd_up
	bgd_grid["upright"] = new_bgd_upright
	bgd_grid["upleft"] = new_bgd_upleft
	
	old_down.queue_free()
	old_downright.queue_free()
	old_downleft.queue_free()
