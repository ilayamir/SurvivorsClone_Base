extends CharacterBody2D

@export var movement_speed = 20.0
var movement_speed_base
@export var hp = 10
var maxhp
@export var knockback_recovery = 3.5
@export var knockback_recovery_base = 3.5
@export var experience = 1
@export var enemy_damage = 1
@export var gem_drop_chance = 0.6
@export var crit_vul = false
@export var base_color = Color(1,1,1,1)
var knockback = Vector2.ZERO
var curr_pos = Vector2.ZERO
var dead = false
var stagger_threshold
var stagger = false

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
@onready var hideTimer = $HideTimer
@onready var reset_location_timer = $ResetLocTimer
@onready var collision = $SoftCollisionBox

var exp_gem = preload("res://Objects/experience_gem.tscn")
var floor_meat = preload("res://Objects/floor_meat.tscn")
var ult_potion = preload("res://Objects/ult_potion.tscn")
var gem_magnet = preload("res://Objects/gem_magnet.tscn")
var spr_green = preload("res://Textures/Enemy/slime_green.png")
var spr_blue= preload("res://Textures/Enemy/slime_blue.png")
var spr_red = preload("res://Textures/Enemy/slime_pink.png")
var spr_1 = preload("res://Textures/Enemy/skell_1.png")
var spr_2 = preload("res://Textures/Enemy/skell_2.png")
var spr_3 = preload("res://Textures/Enemy/skell_3.png")

var direction = Vector2.ZERO
signal remove_from_array(object)

var screen_size

func _ready():
	if is_in_group("slime"):
		var color = randi_range(1,2)
		if color == 1:
			sprite.texture = spr_green
		else:
			sprite.texture = spr_blue
	if is_in_group("skell"):
		var color = randi_range(1,3)
		if color == 1:
			sprite.texture = spr_1
		elif color == 2:
			sprite.texture = spr_2
		else:
			sprite.texture = spr_3
	maxhp = hp
	stagger_threshold = clamp(int(hp*2/5),1,maxhp)
	movement_speed_base = movement_speed
	if is_in_group("rusher"):
		$RushingTimer.start()
	var anim_spd = randf_range(0.9,1.1)
	anim.speed_scale *= anim_spd
	anim.play("walk")
	hitBox.damage = enemy_damage
	$GetDirTimer.wait_time = 0.5
	screen_size = get_viewport_rect().size
	hideTimer.wait_time = 1
	direction = global_position.direction_to(player.global_position)
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false
	velocity = direction*movement_speed

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	velocity = direction*movement_speed
	velocity += knockback
	if collision.is_colliding():
		velocity+= collision.get_push_vector() * 20
	move_and_slide()

func death():
	AudioManager.play_positional("death", global_position)
	emit_signal("remove_from_array", self)
	if self.is_in_group("boss"):
		player.boss_flag = 1
		player.death_timer.start()
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

func _on_hurt_box_hurt(damage, angle, knockback_amount, special_effect):
	hp -= damage
	if !stagger:
		knockback = angle * knockback_amount
		if is_in_group("boss"):
			stagger_threshold -= damage
	if stagger_threshold <= 0:
		staggered()
	if hp<=0:
		death()
	else:
		if special_effect!="none":
			if special_effect == "crit_vul":
				base_color = Color(3,1,3)
				sprite.modulate = base_color
				crit_vul = true
				$DebuffTimer.start()
		if is_in_group("boss"):
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
		knockback_recovery += 10
		rushTimer.start()

func _on_rush_timer_timeout():
	movement_speed -= 100
	knockback_recovery -= 10

func _on_hide_timer_timeout():
	var location_dif = global_position - curr_pos
	if abs(location_dif.x) > (screen_size.x/2)*1.1 and abs(location_dif.y) > (screen_size.y/2)*1.1:
		visible = false
		collision.call_deferred("set", "disabled", true)
		
	else:
		visible = true
		collision.call_deferred("set", "disabled", false)

func frame_save(amount = 20):
	var rand_disable = randi() % 100
	if rand_disable < amount:
		collision.call_deferred("set", "disabled", true)

func get_random_position(dir):
	var vpr = screen_size * randf_range(1.2,1.5)
	var top_left = Vector2(curr_pos.x - vpr.x/2, curr_pos.y - vpr.y/2)
	var top_right = Vector2(curr_pos.x + vpr.x/2, curr_pos.y - vpr.y/2)
	var bottom_left = Vector2(curr_pos.x - vpr.x/2, curr_pos.y + vpr.y/2)
	var bottom_right = Vector2(curr_pos.x + vpr.x/2, curr_pos.y + vpr.y/2)
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match dir:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)

func _on_reset_loc_timer_timeout():
	if global_position.distance_to(curr_pos) > (screen_size.x/2)*1.4:
		if (global_position.x>curr_pos.x+screen_size.x/2):
			global_position = get_random_position("left")
		elif (global_position.x < curr_pos.x - screen_size.x/2):
			global_position = get_random_position("right")
		elif (global_position.y < curr_pos.y - screen_size.y/2):
			global_position = get_random_position("down")
		else:
			global_position = get_random_position("up")

func _on_debuff_timer_timeout():
	base_color = Color(1,1,1)
	sprite.modulate = base_color
	crit_vul = false

func _on_get_dir_timer_timeout():
	direction = global_position.direction_to(curr_pos)
	if direction.x >= 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
	velocity = direction*movement_speed
	
func update_dir(player_position):
	curr_pos = player_position

func _on_animation_player_animation_finished(_death):
	queue_free()
	
func staggered():
	player.lblstagger.visible = true
	hitBox.set_collision_layer_value(2,false)
	stagger_threshold = int(maxhp*2/5)
	stagger = true
	$StaggerTime.start()
	movement_speed = 0


func _on_stagger_time_timeout():
	player.lblstagger.visible = false
	stagger = false
	movement_speed = movement_speed_base
	hitBox.set_collision_layer_value(2,true)



