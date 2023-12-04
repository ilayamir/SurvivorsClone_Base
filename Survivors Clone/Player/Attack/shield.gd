extends Area2D

var damage = 0
var knockback_amount = 80
@onready var player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta):
	position = player.global_position
