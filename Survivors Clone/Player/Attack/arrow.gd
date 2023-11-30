extends Area2D

var level = 1
var hp = 99999
var speed = 600
var damage = 10
var knockback_amount = 100
var attack_size = 1.0
var sound_off = false
@export var angle = Vector2(1,0).normalized()

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)

# Called when the node enters the scene tree for the first time.
func _ready():
	if !sound_off:
		$AudioStreamPlayer.play()
	rotation = angle.angle() + deg_to_rad(-90)
	match level:
		1:
			damage = 10*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			attack_size = 1.0*(1 + player.spell_size)
		2:
			damage = 10*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			attack_size = 1.0*(1 + player.spell_size)
		3:
			damage = 15*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			attack_size = 1.0*(1 + player.spell_size)
		4:
			damage = 15*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			attack_size = 1.0*(1 + player.spell_size)
		5:
			damage = 20*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			attack_size = 1.0*(1 + player.spell_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += speed*angle*delta


func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
