extends Area2D

@onready var damage = 0
@onready var player = get_tree().get_first_node_in_group("player")
@export var special_effect = "crit_vul"
var target


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = target
	damage = player.experience_level/2 + 5
	$AnimationPlayer.play("hit")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	global_position = target


func _on_animation_player_animation_finished(_anim_name):
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	$light.visible = false


func _on_audio_stream_player_2d_finished():
	queue_free()


