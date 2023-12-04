extends Area2D

var damage = 200
var knockback_amount = 100
var angle = Vector2.ZERO

func _ready():
	pass



func _on_timer_timeout():
	$AnimationPlayer.play("burn")
	$snd.play()

func _physics_process(delta):
	angle = position.direction_to($CollisionShape2D.position)


func _on_animation_player_animation_finished(anim_name):
	queue_free()
