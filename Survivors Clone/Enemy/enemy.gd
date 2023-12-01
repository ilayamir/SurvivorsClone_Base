extends CharacterBody2D

@export var movement_speed = 20.0
var movement_speed_base
@export var hp = 20
var maxhp
@export var knockback_recovery = 3.5
@export var knockback_recovery_base = 3.5
@export var experience = 1
@export var enemy_damage = 1
@export var gem_drop_chance = 0.6
@export var food_drop_chance = 0.001
@export var crit_vul = false
@export var reset_check_time = 1
@export var offscreen_timer = 4
@export var hpxlvl = false
var invis = false
var physic_proccessing_index
var invis_time = 0
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
@onready var rushingTimer = $RushingTimer
@onready var rushTimer = $RushingTimer/RushTimer
@onready var dirTimer = $GetDirTimer
@onready var collision_box = $CollisionShape2D
@onready var hitflash = $hitflash
@onready var debuffTimer = $DebuffTimer
@onready var staggerTimer
@onready var HelperManager = get_tree().get_first_node_in_group("helper")

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
	physic_proccessing_index = get_parent().get_child_count()%3
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
	if hpxlvl:
		hp *= clamp(player.experience_level*0.4,1, 99999)
	maxhp = hp
	stagger_threshold = clamp(int(hp*2/5),1,maxhp)
	movement_speed_base = movement_speed
	if is_in_group("rusher"):
		rushTimer.wait_time = 0.5
		rushingTimer.start(randf_range(8,15))
	var anim_spd = randf_range(0.9,1.1)
	anim.speed_scale *= anim_spd
	if is_in_group("boss"):
		staggerTimer = $StaggerTime
	hitBox.damage = enemy_damage
	dirTimer.wait_time = 0.2
	screen_size = get_viewport_rect().size
	direction = global_position.direction_to(player.global_position).normalized()
	anim.play("walk")
	if direction.x > 0.1:
		sprite.flip_h = true
		if is_in_group("spider_demon") and !dead: anim.play("walk_right")
	elif direction.x < -0.1:
		sprite.flip_h = false
		if is_in_group("spider_demon") and !dead: anim.play("walk")

func _physics_process(delta):
	if (Engine.get_physics_frames()+physic_proccessing_index)%3:
		if invis:
			invis_time+=delta*3
			if invis_time>=offscreen_timer:
				launch()
				invis_time = 0
				invis = false
		if !dead:
			velocity = direction*movement_speed*3
	#		global_position+=velocity
			move_and_slide()
	#		move_and_collide(velocity*delta)

func launch():
	var launch_to = (curr_pos-global_position).normalized()
	global_position = curr_pos+launch_to*(screen_size.x/2 +20)

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
	collision_box.set_deferred("disabled", true)
	var gem_chance = randf_range(0,1)
	var food_chance = randf_range(0,1)
	var ult_chance = randf_range(0,1)
	var magnet_chance = randf_range(0,1)
	if gem_chance<gem_drop_chance:
		var super_gem_chance = randf_range(0,1)
		var new_gem = exp_gem.instantiate()
		if super_gem_chance<0.002:
			new_gem.experience = experience*10
		else:
			new_gem.experience = experience
		new_gem.global_position = global_position
		loot_base.call_deferred("add_child",new_gem)
	if food_chance<food_drop_chance:
		var new_food = floor_meat.instantiate()
		new_food.global_position = global_position + Vector2(5,5)
		loot_base.call_deferred("add_child",new_food)
	if ult_chance<0.001:
		var new_ult = ult_potion.instantiate()
		new_ult.global_position = global_position - Vector2(5,5)
		loot_base.call_deferred("add_child",new_ult)
	if magnet_chance<0.001:
		var new_magnet = gem_magnet.instantiate()
		new_magnet.global_position = global_position - Vector2(-5,5)
		loot_base.call_deferred("add_child",new_magnet)

func _on_hurt_box_hurt(damage, angle, knockback_amount, special_effect="none"):
	hp -= damage
	if !stagger:
		knockback = angle.normalized() * knockback_amount * (100- knockback_recovery) / 100 * 0.1
		velocity = Vector2()
		var knock_pos = position+knockback
		var tween = create_tween()
		var time = clamp(0.002*(100-knockback_recovery),0,0.2)
		tween.tween_property(self, "position", knock_pos, time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.play()
		knockback = Vector2.ZERO
		if is_in_group("boss"):
			stagger_threshold -= damage
	if stagger_threshold <= 0:
		staggered()
	if hp<=0:
		death()
	else:
		hitflash.play("hitflash")
		if special_effect!="none":
			if special_effect == "crit_vul":
				crit_vul = true
				debuffTimer.start()

func _on_hurt_box_hurt_ult(_damage, angle, knockback_amount):
	knockback = angle.normalized() * knockback_amount * 0.3
	velocity = Vector2()
	if is_in_group("rusher"):
		rushTimer.stop()
		rushingTimer.start(randf_range(8,15))
	movement_speed = movement_speed_base
	knockback_recovery = knockback_recovery_base
	var knock_pos = position+knockback
	var tween = create_tween()
	tween.tween_property(self, "position", knock_pos, 0.4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.play()

func _on_rushing_timer_timeout():
	if self.is_in_group("rusher"):
		movement_speed += 80
		knockback_recovery = clamp(knockback_recovery+40, knockback_recovery_base, 100)
		rushTimer.start()

func _on_rush_timer_timeout():
	movement_speed = movement_speed_base
	rushingTimer.start(randf_range(8,15))

func frame_save(amount = 20):
	var rand_disable = randi() % 100
	if rand_disable < amount:
		collision_box.call_deferred("set", "disabled", true)

func get_random_position(dir):
	var vpr = screen_size * randf_range(1,1.2)
	match dir:
		"up","down":
			vpr = screen_size * randf_range(1.3,1.5)
		"left","right":
			vpr = screen_size * randf_range(1.5,1.7)
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

func _on_debuff_timer_timeout():
	crit_vul = false

func _on_get_dir_timer_timeout():
	direction = global_position.direction_to(curr_pos).normalized()
	if direction.x >= 0:
		sprite.flip_h = true
		if is_in_group("spider_demon") and !dead: anim.play("walk_right")
	elif direction.x < 0:
		sprite.flip_h = false
		if is_in_group("spider_demon") and !dead: anim.play("walk")
	
func update_dir(player_position):
	curr_pos = player_position

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		HelperManager.killed()
		queue_free()
	
func staggered():
	player.lblstagger.visible = true
	hitBox.set_collision_layer_value(2,false)
	stagger_threshold = int(maxhp*2/5)
	stagger = true
	staggerTimer.start()
	movement_speed = 0

func _on_stagger_time_timeout():
	player.lblstagger.visible = false
	stagger = false
	movement_speed = movement_speed_base
	if !dead:
		hitBox.set_collision_layer_value(2,true)

func _on_visible_on_screen_notifier_2d_screen_entered():
	sprite.visible = true
	invis = false
	collision_box.call_deferred("set", "disabled", false)

func _on_visible_on_screen_notifier_2d_screen_exited():
	sprite.visible = false
	invis = true
	invis_time = 0
	collision_box.call_deferred("set", "disabled", true)
