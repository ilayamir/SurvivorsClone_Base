extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 0
var attack_size = 1.0
var cd = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO
var pos = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim = $AnimationPlayer

var dmgZone = preload("res://Player/Attack/firepit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	angle = Vector2(0,1)
	match level:
		1:
			hp = 9999
			speed = 150
			damage = 1*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 0
			attack_size = 1.0 * (1 + player.spell_size)
			cd = 1.0
		2:
			hp = 9999
			speed = 150
			damage = 1*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 0
			attack_size = 1.2 * (1 + player.spell_size)
			cd = 1.0
		3:
			hp = 9999
			speed = 150
			damage = 2*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 0
			attack_size = 1.2 * (1 + player.spell_size)
			cd = 0.5
		4:
			hp = 9999
			speed = 150
			damage = 3*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 0
			attack_size = 1.4 * (1 + player.spell_size)
			cd = 0.5
	anim.play("flicker")
		

func _physics_process(delta):
	position.y += delta*speed
	global_position.x = target.x
	if global_position.y > target.y:
		create_damage_zone()
		queue_free()

func create_damage_zone():
	var new_pit = dmgZone.instantiate()
	new_pit.position = position
	new_pit.target = global_position
	new_pit.hp = hp
	new_pit.speed = speed
	new_pit.damage = damage
	new_pit.knockback_amount = knockback_amount
	new_pit.attack_size = attack_size
	new_pit.cd = cd
	get_parent().add_child(new_pit)
	
