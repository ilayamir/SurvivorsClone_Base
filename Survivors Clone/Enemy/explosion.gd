extends Sprite2D
@export var boss = 0 
@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET_2")


func _on_animation_player_animation_finished(_anim_name):
	queue_free()
	if boss == 1:
		player.boss_flag = 1
		player.death()
