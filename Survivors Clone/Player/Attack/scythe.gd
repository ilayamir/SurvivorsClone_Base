extends Area2D

var level = 1
var hp = 9999
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var collision = $Blade
signal remove_from_array(object)

# Called when the node enters the scene tree for the first time.
func _ready():
	damage = player.experience_level/5

func _physics_process(_delta):
	rotation += 0.1
	position = player.global_position
	angle = position.direction_to(collision.global_position)

func enemy_hit(_charge = 1, crit=false):
	AudioManager.play_positional("hit", global_position)
	if crit:
		player.heal(2)
	else:
		player.heal(1)

func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
