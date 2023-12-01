extends Enemy

var spr_1 = preload("res://Textures/Enemy/skell_1.png")
var spr_2 = preload("res://Textures/Enemy/skell_2.png")
var spr_3 = preload("res://Textures/Enemy/skell_3.png")

func extra_enable_things():
	var sprite_shape = randi_range(1,3)
	match sprite_shape:
		1:sprite.texture = spr_1
		2:sprite.texture = spr_2
		3:sprite.texture = spr_3
	particles.texture = sprite.texture
