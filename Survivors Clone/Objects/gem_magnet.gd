extends Area2D

@export var magnet_range = 1000

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	pass

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collect():
	AudioManager.play_collect()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	queue_free()
	return magnet_range

