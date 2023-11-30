extends Node2D

var lightning = preload("res://Utility/lightning_strike.tscn")
@onready var lightning_timer = $Timer
var target = null
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")
var screen_size

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if player.sprite.flip_h == true:
		sprite.flip_h = true
	if player.sprite.flip_h == false:
		sprite.flip_h = false


func _on_timer_timeout():
	anim.play("pre_hit")



func _on_duration_timeout():
	queue_free()


func _on_animation_player_animation_finished(_anim_name):
	target = player.get_random_target()
	var new_lightning = lightning.instantiate()
	new_lightning.position = target
	new_lightning.target = target
	add_child(new_lightning)
	$Timer.start()
