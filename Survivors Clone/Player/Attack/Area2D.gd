extends Area2D

var damage = 100
var knockback = 400
@onready var player = get_tree().get_first_node_in_group("player")
var angle = Vector2.ZERO
@onready var base = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	damage = 100 * (1+player.experience_level*0.03) * (1+player.damage_bonus)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	angle = player.position.direction_to(position)
