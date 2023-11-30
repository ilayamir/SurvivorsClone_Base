extends Node2D
@onready var light = $texturelight
@onready var shadow = $textureshadow
@export var light_scale = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	light.texture_scale = light_scale
	shadow.texture_scale = light_scale/2

func update(new_scale):
	var light_tween = light.create_tween()
	var shadow_tween = shadow.create_tween()
	light_tween.tween_property(light, "texture_scale", new_scale, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	shadow_tween.tween_property(shadow, "texture_scale", new_scale/2, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	light_tween.play()
	shadow_tween.play()
