extends Enemy

var spr_green = preload("res://Textures/Enemy/slime_green.png")
var spr_blue= preload("res://Textures/Enemy/slime_blue.png")

func extra_enable_things():
	var sprite_color = randi_range(0,1)
	if sprite_color==0:
		sprite.texture = spr_green
	else:
		sprite.texture = spr_blue
	particles.texture = sprite.texture

