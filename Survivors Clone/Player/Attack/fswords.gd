extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var disabled = true
var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)
signal pool_back(object)

func _ready():
	pass
	
func shut_down():
	$CollisionShape2D.call_deferred("set","disabled",true)
	visible = false
	disabled = true
	emit_signal("pool_back",self)
	
func reset():
	$Timer.start()
	$CollisionShape2D.call_deferred("set","disabled",false)
	visible = true
	disabled = false
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 1
			speed = 200*(1+player.speed_bonus)
			damage = 4*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 40
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 200*(1+player.speed_bonus)
			damage = 4*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 40
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 1
			speed = 200*(1+player.speed_bonus)
			damage = 4*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 40
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 2
			speed = 200*(1+player.speed_bonus)
			damage = 4*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 40
			attack_size = 1.0 * (1 + player.spell_size)
		5:
			hp = 2
			speed = 200*(1+player.speed_bonus)
			damage = 4*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 40
			attack_size = 1.0 * (1 + player.spell_size)
			
	scale = Vector2(1.0,1.0) * attack_size
	
func _physics_process(delta):
	if !disabled:
		position += angle*speed*delta

func enemy_hit(charge = 1,_crit=false):
	AudioManager.play_positional("hit", global_position)
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()
		#shut_down()
#		queue_free()

func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
	#shut_down()
#	queue_free()
