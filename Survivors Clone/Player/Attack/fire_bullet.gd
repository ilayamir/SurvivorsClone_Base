extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var light_on = false
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)

func _ready():
	if light_on:
		$light.visible = true
	rotation = angle.angle()
	$AnimationPlayer.play("shoot")
	match level:
		1:
			hp = 1
			speed = 250*(1+player.speed_bonus)
			damage = 5*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 250*(1+player.speed_bonus)
			damage = 5*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 1
			speed = 250*(1+player.speed_bonus)
			damage = 6*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 2
			speed = 250*(1+player.speed_bonus)
			damage = 6*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
			$Timer.wait_time = 0.8
		5:
			hp = 2
			speed = 250*(1+player.speed_bonus)
			damage = 7*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
			$Timer.wait_time = 0.7
			
	scale *= attack_size

func _physics_process(delta):
	position += angle*speed*delta

func enemy_hit(charge = 1,_crit=false):
	AudioManager.play_positional("hit", global_position)
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()

func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
