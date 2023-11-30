extends Area2D

var level = 1
var hp = 9999
var speed = 100.0
var damage = 20
var attack_size = 1.0
var knockback_amount = 150

var last_movement = Vector2.ZERO
var angle = Vector2.ZERO
var delt = 0
var flipped = false

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var timer = $Timer
@onready var shield = $Shield
@onready var shield_col = $Shield/CollisionShape2D
signal remove_from_array(object)

func _ready():
	match level:
		1:
			hp = 9999
			speed = 100.0
			damage = 20*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 150
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 9999
			speed = 100.0
			damage = 30*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 150
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 9999
			speed = 100.0
			damage = 30*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 150
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 9999
			speed = 100.0
			damage = 30*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 150
			attack_size = 1.0 * (1 + player.spell_size)
		5:
			hp = 9999
			speed = 100.0
			damage = 30*(1+player.damage_bonus)*(1+player.dmg_inc_per_lvl*player.experience_level)
			knockback_amount = 150
			attack_size = 1.5 * (1 + player.spell_size)
			shield.visible = true
			shield_col.call_deferred("set","disabled",false)
			
	if !flipped:
		match player.sprite.flip_h:
			true:
				angle = Vector2.LEFT
				position.x = player.global_position.x -25 - 50*(attack_size-1)
				position.y = player.global_position.y -25
				rotation_degrees = -90
			false:
				angle = Vector2.RIGHT
				position.x = player.global_position.x +25 + 50*(attack_size-1)
				position.y = player.global_position.y -25
				rotation_degrees = 0
	else:
		match player.sprite.flip_h:
			false:
				angle = Vector2.LEFT
				position.x = player.global_position.x -25 - 50*(attack_size-1)
				position.y = player.global_position.y +47
				rotation_degrees = -180
			true:
				angle = Vector2.RIGHT
				position.x = player.global_position.x +25 + 50*(attack_size-1)
				position.y = player.global_position.y +47
				rotation_degrees = 90
	
	var initial_tween = create_tween()
	initial_tween.tween_property(self,"scale",Vector2(1,1)*attack_size,0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	initial_tween.play()

func _physics_process(_delta):
	delt += 0.9
	if !flipped:
		match player.sprite.flip_h:
			true:
				angle = Vector2.LEFT
				if delt<36:
					self.position.y = player.global_position.y -25 + delt
					self.position.x = player.global_position.x -25 - delt*0.194444 - 50*(attack_size-1)
				else:
					self.position.y = player.global_position.y + 11
					self.position.x = player.global_position.x -32 - 50*(attack_size-1)
				if  self.rotation_degrees > -135:
					self.rotation = -delt*0.02111 + deg_to_rad(-90)
				else:
					self.rotation_degrees = -135
			false:
				angle = Vector2.RIGHT
				if delt<36:
					self.position.y = player.global_position.y - 25 + delt
					self.position.x = player.global_position.x + 25 + delt*0.194444 + 50*(attack_size-1)
				else:
					self.position.y = player.global_position.y + 11
					self.position.x = player.global_position.x + 32 + 50*(attack_size-1)
				if  self.rotation_degrees < 45:
					self.rotation = delt*0.02111 
				else:
					self.rotation_degrees = 45
	else:
		match player.sprite.flip_h:
			true:
				angle = Vector2.RIGHT
				if delt<36:
					self.position.y = player.global_position.y +47 - delt
					self.position.x = player.global_position.x +25 + delt*0.194444 + 50*(attack_size-1)
					self.rotation = -delt*0.02111 + deg_to_rad(90)
				else:
					self.position.y = player.global_position.y + 11
					self.position.x = player.global_position.x +32 + 50*(attack_size-1)
					self.rotation_degrees = 45
				
#				if  self.rotation_degrees > 45:
#
#				else:
					
			false:
				angle = Vector2.LEFT
				if delt<36:
					self.position.y = player.global_position.y + 47 - delt
					self.position.x = player.global_position.x - 25 - delt*0.194444 - 50*(attack_size-1)
					self.rotation = delt*0.02111 + deg_to_rad(-180)
				else:
					self.position.y = player.global_position.y + 11
					self.position.x = player.global_position.x - 32 - 50*(attack_size-1)
					self.rotation_degrees = -135


func enemy_hit(_charge = 1, _crit=false):
	AudioManager.play_positional("hit", global_position)

func _on_timer_timeout():
	emit_signal("remove_from_array",self)
	queue_free()
	
