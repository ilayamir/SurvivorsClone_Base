extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	$rays.global_position = Vector2(global_position.x-34.667,global_position.y - 102)
	$light.global_position = global_position

func _on_timer_timeout():
	$AnimationPlayer.play("burn")
	$snd.play()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "burn":
		queue_free()
