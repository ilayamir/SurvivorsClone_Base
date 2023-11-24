extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0

var angle = Vector2.ZERO
@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)


# Called when the node enters the scene tree for the first time.
func _ready():
	match level:
		1:
			hp = 9999
			speed = 200*(1+player.speed_bonus)
			damage = 5*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 9999
			speed = 200*(1+player.speed_bonus)
			damage = 5*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 9999
			speed = 200*(1+player.speed_bonus)
			damage = 5*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 2.0 * (1 + player.spell_size)
		4:
			hp = 9999
			speed = 200*(1+player.speed_bonus)
			damage = 6*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 2 * (1 + player.spell_size)
		
		5:
			hp = 9999
			speed = 200*(1+player.speed_bonus)
			damage = 7*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 200
			attack_size = 2 * (1 + player.spell_size)
			
	scale = Vector2(1.0,1.0) * attack_size
	

func enemy_hit(_charge = 1, _crit=false):
	AudioManager.play_positional("hit", global_position)
