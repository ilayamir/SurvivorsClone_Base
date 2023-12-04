extends CharacterBody2D
class_name Enemy

const CONTAINER = Vector2(4000,4000)

@export var basehp = 0.0
@export var base_speed = 0.0
@export var gem_drop_chance = 0.0
@export var food_drop_chance = 0.0
@export var knockback_res = 0
@export var enemy_damage = 0
@export var experience = 0
@export var time_before_loc_reset = 0.0
@export var rusher = false
@export var hpXlevel = false
@export var linear_movement = false
@export var staggerable = false
@export var boss = false
@export var in_flock = false
@export var drops_unmergable_gems = false

var hp = 0.0
var maxhp = 0.0
var speed = 0.0
var stagger_threshold = 0
var direction = Vector2.ZERO
var curr_player_pos = Vector2.ZERO
var crit_vul = false
var physic_proccessing_index = 1
var invis_time = 0.0
var disabled = true
var invis = false
var staggered = false
var dead = false
var exp_gem = preload("res://Objects/experience_gem.tscn")
var floor_meat = preload("res://Objects/floor_meat.tscn")
var screen_size = Vector2.ZERO

@onready var collision = $CollisionShape2D
@onready var sprite = $EnemyBase/Sprite2D
@onready var hit_box_collision = $EnemyBase/HitBox/CollisionShape2D
@onready var hurt_box_collision = $EnemyBase/HurtBox/CollisionShape2D
@onready var hitbox = $EnemyBase/HitBox
@onready var anim = $AnimationPlayer
@onready var hitflash = $HitFlash
@onready var rushing_timer = $EnemyBase/RushingTimer
@onready var rush_timer = $EnemyBase/RushingTimer/RushTime
@onready var get_dir_timer = $EnemyBase/GetDirTimer
@onready var stagger_timer = $EnemyBase/StaggerTimer
@onready var debuff_timer = $EnemyBase/DebuffTimer
@onready var particles = $EnemyBase/GPUParticles2D
@onready var disable_timer = $EnemyBase/DisableNetTimer
@onready var helper_manager = get_tree().get_first_node_in_group("helper")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")

signal remove_from_array(object)
signal pool_back(object, type)

func _ready():
	#enable()
	pass

func enable():
	disabled = false
	crit_vul = false
	visible = true
	invis = false
	staggered = false
	dead = false
	disable_timer.connect("timeout",Callable(self,"disable_check"))
	screen_size = get_viewport_rect().size
	curr_player_pos = player.global_position
	direction = global_position.direction_to(curr_player_pos)
	if in_flock:
		direction = Vector2(-screen_size.x,screen_size.y).normalized() if global_position.x>curr_player_pos.x else Vector2(screen_size.x,screen_size.y).normalized()
	if direction.x>0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	hp = basehp
	if hpXlevel:
		hp = clamp(hp*player.experience_level*0.4, hp, 99999)
	maxhp = hp
	if rusher:
		rushing_timer.wait_time = randi_range(7,14)
		rushing_timer.start()
		rush_timer.wait_time = 1
	if staggerable:
		stagger_timer.wait_time = 7
		stagger_threshold = maxhp*2/5
	speed = base_speed
	collision.set_deferred("disabled",false)
	hurt_box_collision.set_deferred("disabled",false)
	hit_box_collision.set_deferred("disabled",false)
	hitbox.damage = enemy_damage
	invis_time = 0
	#physic_proccessing_index = get_parent().get_parent().enemies_on_screen%3
	get_dir_timer.wait_time = 0.4
	get_dir_timer.start()
	anim.speed_scale *= randf_range(0.9,1.1)
	sprite.modulate = Color(1,1,1,1)
	anim.play("walk")
	particles.texture = sprite.texture
	particles.emission_rect_extents = hurt_box_collision.shape.size
	extra_enable_things()

func disable():
	emit_signal("remove_from_array", self)
	disabled = true
	visible = false
	if rusher:
		rushing_timer.stop()
		rush_timer.stop()
	if staggerable:
		stagger_timer.stop()
	collision.set_deferred("disabled",true)
	hurt_box_collision.set_deferred("disabled",true)
	hit_box_collision.set_deferred("disabled",true)
	get_dir_timer.stop()
	anim.stop()
	global_position = CONTAINER
	extra_disable_things()

func extra_enable_things():
	pass

func extra_disable_things():
	pass

func _physics_process(delta):
	if !disabled:
		if !dead: #(Engine.get_physics_frames()+physic_proccessing_index)%3 == 0 and !dead:
			velocity = direction*speed
			move_and_slide()
		if invis:
				invis_time+=delta*2
				if invis_time>time_before_loc_reset:
					launch()
					invis_time = 0

func launch():
	if !disabled and !linear_movement:
		var launch_to = Vector2.ZERO
		if global_position.x >= curr_player_pos.x + screen_size.x/2:
			launch_to.x = curr_player_pos.x - screen_size.x/2-80
			launch_to.y = randf_range(curr_player_pos.y-screen_size.y/2+60, curr_player_pos.y+screen_size.y/2-60)
		elif global_position.x <= curr_player_pos.x - screen_size.x/2:
			launch_to.x = curr_player_pos.x + screen_size.x/2+80
			launch_to.y = randf_range(curr_player_pos.y-screen_size.y/2+60, curr_player_pos.y+screen_size.y/2-60)
		elif global_position.y> curr_player_pos.y + screen_size.y/2:
			launch_to.y = curr_player_pos.y - screen_size.y/2-60
			launch_to.x = randf_range(curr_player_pos.x-screen_size.x/2+80, curr_player_pos.x+screen_size.x/2-80)
		elif global_position.y< curr_player_pos.y - screen_size.y/2:
			launch_to.y = curr_player_pos.y + screen_size.y/2+60
			launch_to.x = randf_range(curr_player_pos.x-screen_size.x/2+80, curr_player_pos.x+screen_size.x/2-80)
		global_position = launch_to
	if !disabled and linear_movement:
		dead = true
		queue_free()

func _on_rushing_timer_timeout():
	if !disabled:
		speed += 80
		rush_timer.start()

func _on_rush_time_timeout():
	if !disabled:
		speed = base_speed
		rushing_timer.start(randi_range(8,15))

func _on_get_dir_timer_timeout():
	if !disabled and !linear_movement:
		direction = global_position.direction_to(curr_player_pos)
		if direction.x>0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

func _on_debuff_timer_timeout():
	if !disabled:
		crit_vul = false

func frame_save(amount = 20):
	if !disabled:
		var rand_disable = randi() % 100
		if rand_disable < amount:
			collision.call_deferred("set", "disabled", true)
			anim.stop()

func _on_stagger_timer_timeout():
	if !disabled:
		staggered = false
		player.lblstagger.visible = false
		speed = base_speed
		hit_box_collision.set_deferred("disabled",false)

func _on_visible_on_screen_notifier_2d_screen_entered():
	if !disabled:
		sprite.visible = true
		collision.set_deferred("disabled", false)
		invis = false

func _on_visible_on_screen_notifier_2d_screen_exited():
	if !disabled:
		sprite.visible = false
		collision.set_deferred("disabled", true)
		invis = true
		invis_time = 0

func stagger():
	if !disabled:
		player.lblstagger.visible = true
		stagger_threshold = int(maxhp*2/5)
		staggered = true
		speed = 0
		hit_box_collision.set_deferred("disabled",true)
		stagger_timer.start()

func _on_hurt_box_hurt(damage, angle, knockback_amount, special_effect):
	if !disabled and !dead:
		hp -= damage
		if staggerable and !staggered:
			stagger_threshold -= damage
			if stagger_threshold <= 0:
				stagger()
		elif !staggered:
			var knockback = angle.normalized() * knockback_amount * (100- knockback_res) / 100 * 0.1
			velocity = Vector2.ZERO
			var knock_pos = position+knockback
			var tween = create_tween()
			var time = clamp(0.002*(100-knockback_res),0,0.2)
			tween.tween_property(self, "position", knock_pos, time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			tween.play()
			if special_effect != "none":
				if special_effect == "crit_vul":
					crit_vul = true
					debuff_timer.start()
		if hp<=0:
			dead = true
			death()
		else:
			hitflash.play("hitflash")

func _on_hurt_box_hurt_ult(_damage, angle, knockback_amount):
	if !disabled and !dead:
		var knockback = angle.normalized() * knockback_amount * 0.3
		velocity = Vector2.ZERO
		var knock_pos = position+knockback
		var tween = create_tween()
		var time = 0.4
		if rusher:
			rush_timer.stop()
			speed = base_speed
			rushing_timer.start(randi_range(8,15))
		tween.tween_property(self, "position", knock_pos, time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.play()

func update_dir(pos):
	if !linear_movement:
		curr_player_pos = pos

func death():
	if !disabled:
		disabled = true
		disable_timer.start()
		AudioManager.play_positional("death", global_position)
		anim.play("death")
		if boss:
			player.boss_flag = 1
			player.death_timer.start()
		collision.set_deferred("disabled",true)
		hurt_box_collision.set_deferred("disabled",true)
		hit_box_collision.set_deferred("disabled",true)
		var gem_chance = randf_range(0,1)
		var food_chance = randf_range(0,1)
		if gem_chance<gem_drop_chance:
			var super_gem_chance = randf_range(0,1)
			var new_gem = exp_gem.instantiate()
			if super_gem_chance<0.002:
				new_gem.experience = experience*10
			else:
				new_gem.experience = experience
			new_gem.global_position = global_position
			new_gem.unmergeable = drops_unmergable_gems
			loot_base.call_deferred("add_child",new_gem)
		if food_chance<food_drop_chance:
			var new_food = floor_meat.instantiate()
			new_food.global_position = global_position + Vector2(5,5)
			loot_base.call_deferred("add_child",new_food)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		#emit_signal("pool_back",self)
		helper_manager.killed()
		queue_free()
		#disable()

func disable_check():
	if disabled:
		queue_free()
