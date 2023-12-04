extends Area2D
var damage = 5
var level = 1
var cd = 1
var lifeleech = false
var knockback_amount = 100
var attack_size = 1.0

@onready var player = get_tree().get_first_node_in_group("player")

func ready():
	update()

func update():
	$AnimationPlayer.play("rotate")
	match level:
		1:
			damage = 1*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)+(player.maxhp*1.5/100)
			knockback_amount = 50
			attack_size = 1.0 * (1 + player.spell_size)
			cd = 1 * (1-player.spell_cooldown)
		2:
			damage = 2*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)+(player.maxhp*1.5/100)
			knockback_amount = 50
			attack_size = 1.0 * (1 + player.spell_size)
			cd = 1 * (1-player.spell_cooldown)
		3:
			damage = 2*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)+(player.maxhp*1.5/100)
			knockback_amount = 50
			attack_size = 1.5 * (1 + player.spell_size)
			cd = 1 * (1-player.spell_cooldown)
		4:
			damage = 2*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)+(player.maxhp*1.5/100)
			knockback_amount = 50
			attack_size = 1.5 * (1 + player.spell_size)
			cd = 0.75 * (1-player.spell_cooldown)
		5:
			damage = 3*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)+(player.maxhp*1.5/100)
			knockback_amount = 50
			attack_size = 2 * (1 + player.spell_size)
			cd = 0.6 * (1-player.spell_cooldown)
			lifeleech = true
	scale = Vector2(0.8,0.8) * attack_size


func enemy_hit(_charge = 1, _crit=false):
	if lifeleech and $Timer.is_stopped():
		player.heal(1)
		$Timer.start()
	if $Timer2.is_stopped():
		AudioManager.play_positional("hit", position)
		$Timer2.start()
