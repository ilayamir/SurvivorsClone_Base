extends Node2D

var level = 1
var ammo = 20
@onready var player = get_tree().get_first_node_in_group("player")
var angle = Vector2.ZERO
var arrow = preload("res://Player/Attack/arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	angle = player.last_movement.normalized()
	rotation = angle.angle() + deg_to_rad(135)

func _on_shoot_timer_timeout():
	if ammo > 0:
		$AnimationPlayer.play("shoot")
		ammo -= 1
		$ShootTimer.start()

func _on_animation_player_animation_finished(_shoot):
	var new_arrow = arrow.instantiate()
	new_arrow.level = level
	new_arrow.position = player.position
	new_arrow.angle = angle
	get_parent().add_child(new_arrow)
	if ammo == 0:
		queue_free()
