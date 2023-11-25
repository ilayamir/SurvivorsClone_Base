extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var additional_ammo = 0
var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 1
			speed = 100*(1+player.speed_bonus)
			damage = 6*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level) 
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 100*(1+player.speed_bonus)
			damage = 6*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level) -(1-additional_ammo)
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size) * (1 - (1-additional_ammo)*0.15)
		3:
			hp = 2
			speed = 150*(1+player.speed_bonus)
			damage = 8*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level) -(1-additional_ammo)
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size) * (1 - (1-additional_ammo)*0.15)
		4:
			hp = 2
			speed = 150*(1+player.speed_bonus)
			damage = 8*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level) -(1-additional_ammo)
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size) * (1 - (1-additional_ammo)*0.15)
		5:
			hp = 2
			speed = 200*(1+player.speed_bonus)
			damage = 8*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level) -(3-additional_ammo)
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size) * (1 - (3-additional_ammo)*0.15)
	
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
func _physics_process(delta):
	position += angle*speed*delta

func enemy_hit(charge = 1, _crit=false):
	AudioManager.play_positional("hit", global_position)
	hp -= charge
	if hp <= 0:
		if additional_ammo>0:
			additional_ammo-=1
			var icespear_attack = player.iceSpear.instantiate()
			icespear_attack.position = position
			icespear_attack.target = player.get_random_target()
			icespear_attack.level = player.icespear_level
			icespear_attack.additional_ammo = additional_ammo
			player.call_deferred("add_child",icespear_attack)
		emit_signal("remove_from_array", self)
		queue_free()


func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
