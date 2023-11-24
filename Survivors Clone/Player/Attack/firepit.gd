extends Area2D

var hp = 9999
var speed = 100
var damage = 5
var knockback_amount = 0
var attack_size = 1.0
var cd = 1.0
var target

@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0.5),1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	scale *= attack_size
	anim.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	global_position = target


func _on_timer_timeout():
	queue_free()
