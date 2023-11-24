extends CharacterBody2D

@export var movement_speed = 150.0
@export var left = true
@onready var target = Vector2.ZERO
var screen_size


func _ready():
	screen_size = get_viewport_rect().size
	if left:
		target.x = -screen_size.x/2-40
	else:
		target.x = screen_size.x/2+40
	target.y = screen_size.y/2+40

func _physics_process(delta):
	position += Vector2(-1,screen_size.y/screen_size.x)*movement_speed*delta
	if position.y>target.y:
		queue_free()
