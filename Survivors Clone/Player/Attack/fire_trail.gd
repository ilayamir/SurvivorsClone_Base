extends Area2D

var level = 1
var damage = 5
var attack_size = 1.0
var cd = 0.5
var duration = 2.0
@onready var player = get_tree().get_first_node_in_group("player")
var fade = 1
var base_dmg = 5
signal remove_from_array(object)


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("flicker")
	match level:
		1:
			damage = 1*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)+(player.movement_speed*2/100)
			attack_size = 0.5 * (1 + player.spell_size)
			cd = 0.5
			duration = 1.0 + (player.movement_speed*2/100)
		2:
			damage = 2*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)+(player.movement_speed*2/100)
			attack_size = 0.5 * (1 + player.spell_size)
			cd = 0.5
			duration = 1.0 + (player.movement_speed*2/100)
		3:
			damage = 2*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)+(player.movement_speed*2/100)
			attack_size = 0.5 * (1 + player.spell_size)
			cd = 0.5
			duration = 2.0 + (player.movement_speed*2/100)
		4:
			damage = 3*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)+(player.movement_speed*2/100)
			attack_size = 0.5 * (1 + player.spell_size)
			cd = 0.5
			duration = 3.0 + (player.movement_speed*2/100)
	scale = Vector2(1,1) * attack_size
	base_dmg = damage
	$Timer.wait_time = duration
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	fade -= delta/duration
	scale -= Vector2((delta/duration)*attack_size, (delta/duration)*attack_size)
	damage -= (delta/duration)*base_dmg
	if damage<1:
		damage = 1
	$Sprite2D.modulate = Color(1,1,1,fade)

func enemy_hit(_charge = 1,_crit=false):
	if $Timer2.is_stopped():
		AudioManager.play_positional("hit", global_position)
		$Timer2.start()


func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
