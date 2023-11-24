extends CharacterBody2D

@export var movement_speed = 100.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var knockback_recovery_base = 3.5
@export var experience = 1
@export var enemy_damage = 1
@export var gem_drop_chance = 0.6
@export var crit_vul = false
@export var base_color = Color(1,1,1,1)
var knockback = Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var anim = $AnimationPlayer
@onready var snd_hit = $snd_hit
@onready var hitBox = $HitBox
@onready var hurtBox = $HurtBox
@onready var UltRecTimer = $UltRecovery
@onready var rushingTimer = $RushingTimer
@onready var rushTimer = $RushingTimer/RushTimer
@onready var collision = $SoftCollisionBox
@onready var hideTimer = $HideTimer
var direction
var dead = false
var stagger = false
var screen_size
var in_flock = false
var top_right = 0
var death_anim = preload("res://Enemy/explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")
var floor_meat = preload("res://Objects/floor_meat.tscn")
var ult_potion = preload("res://Objects/ult_potion.tscn")
var gem_magnet = preload("res://Objects/gem_magnet.tscn")


signal remove_from_array(object)

func _ready():
	screen_size = get_viewport_rect().size
	anim.play("walk")
	hitBox.damage = enemy_damage
	hideTimer.wait_time = 1
	if !in_flock:
		direction = global_position.direction_to(player.global_position)
	else:
		if top_right==0:
			direction = Vector2(-screen_size.x,screen_size.y).normalized()
		else:
			direction = Vector2(screen_size.x,screen_size.y).normalized()
	if direction.x > 0.1:
			sprite.flip_h = false
	elif direction.x < -0.1:
			sprite.flip_h = true
	velocity = direction*movement_speed

func death():
	AudioManager.play_positional("death", global_position)
	emit_signal("remove_from_array", self)
	if self.is_in_group("boss"):
		player.boss_flag = 1
		player.death()
	anim.stop()
	anim.play("death")
	if !dead:
		hurtBox.queue_free()
		hitBox.queue_free()
	dead = true
	collision.set("disabled", true)
	var gem_chance = randf_range(0,1)
	var food_chance = randf_range(0,1)
	var ult_chance = randf_range(0,1)
	var magnet_chance = randf_range(0,1)
	if gem_chance<gem_drop_chance:
		var super_gem_chance = randf_range(0,1)
		var new_gem = exp_gem.instantiate()
		if super_gem_chance<0.005:
			new_gem.experience = experience*10
		else:
			new_gem.experience = experience
		new_gem.global_position = global_position
		loot_base.call_deferred("add_child",new_gem)
	if food_chance<0.003:
		var new_food = floor_meat.instantiate()
		new_food.global_position = global_position + Vector2(5,5)
		loot_base.call_deferred("add_child",new_food)
	if ult_chance<0.003:
		var new_ult = ult_potion.instantiate()
		new_ult.global_position = global_position - Vector2(5,5)
		loot_base.call_deferred("add_child",new_ult)
	if magnet_chance<0.003:
		var new_magnet = gem_magnet.instantiate()
		new_magnet.global_position = global_position - Vector2(-5,5)
		loot_base.call_deferred("add_child",new_magnet)

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	velocity = direction*movement_speed
	velocity += knockback
	if collision.is_colliding():
		velocity+= collision.get_push_vector() * 5
	move_and_slide()

func _on_hurt_box_hurt(damage, angle, knockback_amount, special_effect):
	hp -= damage
	knockback = angle * knockback_amount
	if hp<=0:
		death()
	else:
		AudioManager.play_positional("hit", global_position)
		if special_effect!="none":
			if special_effect == "crit_vul":
				base_color = Color(3,1,3)
				sprite.modulate = base_color
				crit_vul = true
				$DebuffTimer.start()
		var tween = sprite.create_tween()
		tween.tween_property(sprite, "modulate", Color(8,8,8,1), 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.play()
		var tween2 = sprite.create_tween()
		tween2.tween_property(sprite, "modulate", base_color, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween2.play()

func _on_hurt_box_hurt_ult(_damage, angle, knockback_amount):
	knockback = angle * knockback_amount
	knockback_recovery = 1
	UltRecTimer.start()

func _on_ult_recovery_timeout():
	knockback_recovery = knockback_recovery_base

func _on_rushing_timer_timeout():
	if self.is_in_group("rusher"):
		movement_speed += 100
		rushTimer.start()

func _on_rush_timer_timeout():
	movement_speed -= 100

func frame_save(amount = 20):
	var rand_disable = randi() % 100
	if rand_disable < amount:
		collision.call_deferred("set", "disabled", true)

func _on_debuff_timer_timeout():
	base_color = Color(1,1,1)
	sprite.modulate = base_color
	crit_vul = false

func _on_hide_timer_timeout():
	var location_dif = global_position - player.global_position
	if abs(location_dif.x) > (screen_size.x/2) and abs(location_dif.y) > (screen_size.y/2):
		queue_free()

func update_dir(_pos):
	pass
