extends CharacterBody2D

var movement_speed = 50.0
var hp = 80.0
var maxhp = 80.0
var last_movement = Vector2.RIGHT
var time = 0
var face_dir = Vector2.LEFT
var dashlength = 0.2
var dashspeed = 400
@export var end_time = 360

var experience = 0
var stagger = false
var near_death = false
@onready var invul = false
var experience_level = 1
var collected_experience = 0
var weapon_count = 0
var max_weapon_count = 3
@export var ult_cd = 75
var boss_flag = 0
var final_boss = null
var final_boss_hp = 0
var shift_mod = 0
var scythe_on = false
var eye_on = false
var screen_size

#Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn") #dark
var tornado = preload("res://Player/Attack/tornado.tscn") #dark
var javelin = preload("res://Player/Attack/javelin.tscn") #holy
var fsword = preload("res://Player/Attack/fswords.tscn") #holy
var sword = preload("res://Player/Attack/sword.tscn") #holy
var scythe = preload("res://Player/Attack/scythe.tscn")
var eye = preload("res://Player/Attack/eye.tscn")
var comet = preload("res://Player/Attack/comet.tscn") #fire
var fire_bullet = preload("res://Player/Attack/fire_bullet.tscn") #fire
var katana = preload("res://Player/Attack/katana_manager.tscn") #fire
var hell_circle = preload("res://Player/Attack/hell_circle.tscn") #dark
var fire_trail = preload("res://Player/Attack/fire_trail.tscn") #fire
var bow = preload("res://Player/Attack/bow.tscn") #holy
var angel = preload("res://Player/Attack/angel_attack.tscn")

#AttackNodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")
@onready var tornadoTimer = get_node("%TornadoTimer")
@onready var tornadoAttackTimer = get_node("%TornadoAttackTimer")
@onready var javelinBase = get_node("%JavelinBase")
@onready var fSwordTimer = get_node("%FSwordTimer")
@onready var fSwordAttackTimer = get_node("%FSwordAttackTimer")
@onready var swordTimer = get_node("%SwordTimer")
@onready var swordAttackTimer = get_node("%SwordAttackTimer")
@onready var cometTimer = get_node("%CometTimer")
@onready var cometAttackTimer = get_node("%CometAttackTimer")
@onready var firegunTimer = get_node("%ShotgunTimer")
@onready var firegunAttackTimer = get_node("%ShotgunAttackTimer")
@onready var katanaTimer = get_node("%KatanaTimer")
@onready var katanaAttackTimer = get_node("%KatanaAttackTimer")
@onready var weapon_update = get_node("%WeaponUpdate")
@onready var trail_timer = get_node("%TrailTimer")
@onready var bowTimer = get_node("%BowTimer")
@onready var hell_base = []
@onready var weapon_pool = get_node("%weaponPool")

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0
var crit_chance = 0.1
var damage_bonus = 0
var speed_bonus = 0
var exp_bonus = 0
var dmg_inc_per_lvl = 0.01

#Comet
var comet_ammo = 0
var comet_baseammo = 0
var comet_attackspeed = 4
var comet_level = 0

#Bow
var bow_ammo = 0
var bow_level = 0
var bow_attackspeed = 6

#HellCircle
var hell_circle_level = 0

#Firegun
var firegun_ammo = 0
var firegun_baseammo = 0
var firegun_attackspeed = 2.8
var firegun_level = 0

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 0
var icespear_additional_ammo = 0
var icespear_attackspeed = 1.2
var icespear_level = 0

#Katana
var katana_ammo = 0
var katana_baseammo = 0
var katana_attackspeed = 3
var katana_level = 0

#FireTrail
var trail_cd = 0.1
var trail_level = 0

#Tornado
var tornado_ammo = 0
var tornado_baseammo = 0
var tornado_attackspeed = 3
var tornado_level = 0

#Javelin
var javelin_ammo = 0
var javelin_level = 0

#FSword
var fsword_ammo = 0
var fsword_baseammo = 0
var fsword_attackspeed = 1.3
var fsword_level = 0
var change = 0

#HSword
var sword_ammo = 0
var sword_baseammo = 0
var sword_attackspeed = 7
var sword_level = 0

#Enemy Related
var enemy_close = []

#Misc
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%WalkTimer")
@onready var ultTimer = get_node("%UltTimer")
@onready var ultDuration = get_node("%UltDuration")
@onready var ultRun = get_node("%ActivationTime")
@onready var magnet_timer = get_node("%MagnetTimer")
@onready var collect_area = get_node("%GrabArea")
@onready var backgrnd = get_tree().get_first_node_in_group("background")
@onready var funny_timer = get_node("%ShiftTimer")
var dmg_num = preload("res://Utility/damage_number.tscn")
var shadow = preload("res://Utility/shadow.tscn")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var snd_shot = get_node("%snd_shotgun")
@onready var death_timer = get_node("%BossDeathTimer")
@onready var dash = $Dash
@onready var hurtbox = $HurtBox
@onready var vuln_timer = get_node("%vulnTimer")

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%lbl_level")
@onready var ultBar = get_node("%UltBar")
@onready var ultActiavte = get_node("%UltPushArea")
@onready var levelPanel = get_node("%LevelUp")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var sndLevelUp = get_node("%snd_levelup")
@onready var healthBar = get_node("%HealthBar")
@onready var lblTimer = get_node("%lblTimer")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var collectedUlt = get_node("%CollectedUlt")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")
@onready var deathPanel = get_node("%DeathPanel")
@onready var lblResult = get_node("%lbl_Result")
@onready var sndVictory = get_node("%snd_victory")
@onready var sndVictoryBoss = get_node("%snd_victory_boss")
@onready var sndLose = get_node("%snd_lose")
@onready var pausePanel = get_node("%PausePanel")
@onready var bossHealthBar = get_node("%BossHealthBar")
@onready var lblstagger = get_node("%lbl_stagger")
@onready var lblHelp = get_node("%lbl_help")
@onready var HelperManager = get_tree().get_first_node_in_group("helper")
#music
@onready var bgm = get_node("%bgm_snd")
@onready var boss_bgm = get_node("%boss_snd")

#Signal
signal playerdeath

func _ready():
	time = 0
	upgrade_character("fsword1")
	upgrade_character("fsword2")
	upgrade_character("fsword3")
	upgrade_character("fsword4")
	upgrade_character("fsword5")
	upgrade_character("icespear1")
	upgrade_character("icespear2")
	upgrade_character("icespear3")
	upgrade_character("icespear4")
	upgrade_character("icespear5")
	upgrade_character("ring1")
	upgrade_character("ring2")
	attack()
	set_expbar(experience, calculate_experiencecap())
	healthBar.max_value = maxhp
	healthBar.value = hp
	ultTimer.wait_time = ult_cd
	ultBar.max_value = ult_cd
	ultRun.wait_time = 0.1
	ultTimer.start()
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	movement(delta)
	

func _process(_delta):
	ultBar.value = ult_cd - ultTimer.time_left
	if final_boss != null:
		bossHealthBar.max_value = final_boss_hp
		bossHealthBar.value = final_boss.hp

func _input(event):
	if event.is_action_pressed("ult") and ultTimer.is_stopped():
		ultimate()
		ultTimer.wait_time = ult_cd
		ultTimer.start()
	if event.is_action_pressed("pause") and !get_tree().paused:
		pause()

func pause():
	pausePanel.visible = true
	get_tree().paused = true
	var tween = pausePanel.create_tween()
	tween.tween_property(pausePanel,"position",Vector2(220,55),1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func get_movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(x_mov,y_mov)

func movement(delta):
	var mov_speed
	if Input.is_action_just_pressed("dash") and $Dash/dash_cd.is_stopped():
		dash.start_dash(0.2)
		trail_timer.wait_time /= 3
		$Dash/dash_cd.start()
	if dash.is_dashing():
		mov_speed = movement_speed*3
	else:
		mov_speed = movement_speed
		trail_timer.wait_time = trail_cd * (1-spell_cooldown)
	
	var mov = get_movement()
	if mov.x > 0:
		sprite.flip_h = false
	elif mov.x < 0:
		sprite.flip_h = true
	if mov!=Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes -1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	if mov==Vector2.ZERO:
		if velocity.length() > (delta *600):
			velocity-=velocity.normalized() * (delta*600)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += mov*delta*1500
		velocity = velocity.limit_length(mov_speed)
		if $ShadowTimer.time_left == 0:
			$ShadowTimer.start()
	
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed * (1-spell_cooldown)
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed * (1-spell_cooldown)
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
	if javelin_level > 0:
		spawn_javelin()
	if hell_circle_level > 0:
		update_hell()
	if fsword_level > 0:
		fSwordTimer.wait_time = fsword_attackspeed * (1-spell_cooldown)
		if fSwordTimer.is_stopped():
			fSwordTimer.start()
	if sword_level > 0:
		swordTimer.wait_time = sword_attackspeed * (1-spell_cooldown)
		if swordTimer.is_stopped():
			swordTimer.start()
	if comet_level > 0:
		cometTimer.wait_time = comet_attackspeed * (1-spell_cooldown)
		if cometTimer.is_stopped():
			cometTimer.start()
	if firegun_level > 0:
		firegunTimer.wait_time = firegun_attackspeed * (1-spell_cooldown)
		if firegunTimer.is_stopped():
			firegunTimer.start()
	if katana_level > 0:
		katanaTimer.wait_time = katana_attackspeed* (1-spell_cooldown)
		if katanaTimer.is_stopped():
			katanaTimer.start()
	if trail_level > 0:
		trail_timer.wait_time = trail_cd * (1-spell_cooldown)
		if trail_timer.is_stopped():
			trail_timer.start()
	if bow_level > 0:
		bowTimer.wait_time = bow_attackspeed * (1-spell_cooldown)
		if bowTimer.is_stopped():
			bowTimer.start()

func _on_hurt_box_hurt(damage, _angle, _knockback, _special_effect):
	if !invul:
		hp -= clamp(damage-armor,1.0,999.0)
		if damage>0:
			$snd_hit.play()
			var tween = sprite.create_tween()
			tween.tween_property(sprite, "modulate", Color(4,1,1,1), 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			tween.play()
			var tween2 = sprite.create_tween()
			tween2.tween_property(sprite, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			tween2.play()
		healthBar.max_value = maxhp
		healthBar.value = hp
		if hp <= 0:
			invul = true
			hp = 0
			var roll = randi_range(0,100)
			var chance = HelperManager.chance
			if roll <= chance and HelperManager.cd.is_stopped():
				heal(maxhp/2)
				HelperManager.assisted()
				check_for_assistance(true)
			else:
				check_for_assistance(false)

func check_for_assistance(helped):
	if !helped:
		death()
	else:
		ultActiavte.set_collision_layer_value(3,true)
		ultActiavte.knockback_amount = 500
		ultRun.start(2)
		var texts = ["Our Prayers Have Been Answered", "Seek Redemption", "You Have Been Noticed"]
		lblHelp.text = texts.pick_random()
		var tween = lblHelp.create_tween()
		tween.tween_property(lblHelp,"modulate", Color(1,1,1,1), 2)
		tween.play()
		vuln_timer.start()
		var new_angel = angel.instantiate()
		new_angel.position = position
		get_parent().call_deferred("add_child", new_angel)


func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo + additional_attacks
	iceSpearAttackTimer.start()

func _on_ice_spear_attack_timer_timeout():
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		icespear_attack.additional_ammo = icespear_additional_ammo
		icespear_attack.light_on = true
		add_child(icespear_attack)
		$Attack/snd_ice_spear.play()
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func spawn_javelin():
	var get_javelin_total = javelinBase.get_child_count()
	var calc_spawns = (javelin_ammo + additional_attacks) - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelinBase.add_child(javelin_spawn)
		calc_spawns -= 1
	#Upgrade Javelin
	var get_javelins = javelinBase.get_children()
	for i in get_javelins:
		if i.has_method("update_javelin"):
			i.update_javelin()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.DOWN

func _on_tornado_timer_timeout():
	tornado_ammo += tornado_baseammo + additional_attacks
	tornadoAttackTimer.start()

func _on_tornado_attack_timer_timeout():
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornadoAttackTimer.start()
		else:
			tornadoAttackTimer.stop()

func _on_f_sword_timer_timeout():
	fsword_ammo += fsword_baseammo + additional_attacks
	fSwordAttackTimer.start()

func _on_f_sword_attack_timer_timeout():
	if fsword_ammo > 0:
		var pos = global_position
		if fsword_level == 5:
			change += 10
			change = change%90
			var ext_chance = randf_range(0,1)
			if ext_chance<0.5:
				var fsword1 = weapon_pool.draw_from_pool()
				fsword1.position = pos
				fsword1.angle = Vector2(0,-1).rotated(deg_to_rad(change+45))
				fsword1.level = fsword_level
				fsword1.reset()
				var fsword2 = weapon_pool.draw_from_pool()
				fsword2.position = pos
				fsword2.angle = Vector2(1,0).rotated(deg_to_rad(change+45))
				fsword2.level = fsword_level
				fsword2.reset()
				var fsword3 = weapon_pool.draw_from_pool()
				fsword3.position = pos
				fsword3.angle = Vector2(0,1).rotated(deg_to_rad(change+45))
				fsword3.level = fsword_level
				fsword3.reset()
				var fsword4 = weapon_pool.draw_from_pool()
				fsword4.position = pos
				fsword4.angle = Vector2(-1,0).rotated(deg_to_rad(change+45))
				fsword4.level = fsword_level
				fsword4.reset()
		var mov_dir = get_movement()
		var fsword1 = weapon_pool.draw_from_pool() #up
		fsword1.position = pos
		fsword1.angle = Vector2(0,-1).rotated(deg_to_rad(change))
		fsword1.level = fsword_level
		
		var fsword2 = weapon_pool.draw_from_pool() #right
		fsword2.position = pos
		fsword2.angle = Vector2(1,0).rotated(deg_to_rad(change))
		fsword2.level = fsword_level
		
		var fsword3 = weapon_pool.draw_from_pool() #down
		fsword3.position = pos
		fsword3.angle = Vector2(0,1).rotated(deg_to_rad(change))
		fsword3.level = fsword_level
		
		var fsword4 = weapon_pool.draw_from_pool() #left
		fsword4.position = pos
		fsword4.angle = Vector2(-1,0).rotated(deg_to_rad(change))
		fsword4.level = fsword_level
		
		match mov_dir:
			Vector2(1,0):
				fsword1.angle = fsword1.angle.rotated(deg_to_rad(-10))
				fsword3.angle = fsword3.angle.rotated(deg_to_rad(10))
			Vector2(0,1):
				fsword2.angle = fsword2.angle.rotated(deg_to_rad(-10))
				fsword4.angle = fsword4.angle.rotated(deg_to_rad(10))
			Vector2(-1,0):
				fsword1.angle = fsword1.angle.rotated(deg_to_rad(10))
				fsword3.angle = fsword3.angle.rotated(deg_to_rad(-10))
			Vector2(0,-1):
				fsword2.angle = fsword2.angle.rotated(deg_to_rad(10))
				fsword4.angle = fsword4.angle.rotated(deg_to_rad(-10))
			Vector2(1,1):
				fsword1.angle = fsword1.angle.rotated(deg_to_rad(-15))
				fsword2.angle = fsword2.angle.rotated(deg_to_rad(-15))
				fsword3.angle = fsword3.angle.rotated(deg_to_rad(15))
				fsword4.angle = fsword4.angle.rotated(deg_to_rad(15))
			Vector2(-1,1):
				fsword1.angle = fsword1.angle.rotated(deg_to_rad(15))
				fsword2.angle = fsword2.angle.rotated(deg_to_rad(-15))
				fsword3.angle = fsword3.angle.rotated(deg_to_rad(-15))
				fsword4.angle = fsword4.angle.rotated(deg_to_rad(15))
			Vector2(1,-1):
				fsword1.angle = fsword1.angle.rotated(deg_to_rad(-15))
				fsword2.angle = fsword2.angle.rotated(deg_to_rad(15))
				fsword3.angle = fsword3.angle.rotated(deg_to_rad(15))
				fsword4.angle = fsword4.angle.rotated(deg_to_rad(-15))
			Vector2(-1,-1):
				fsword1.angle = fsword1.angle.rotated(deg_to_rad(15))
				fsword2.angle = fsword2.angle.rotated(deg_to_rad(15))
				fsword3.angle = fsword3.angle.rotated(deg_to_rad(-15))
				fsword4.angle = fsword4.angle.rotated(deg_to_rad(-15))
		fsword1.reset()
		fsword2.reset()
		fsword3.reset()
		fsword4.reset()
		$Attack/snd_fsword.play()
		fsword_ammo -= 1
		if fsword_ammo > 0:
			fSwordAttackTimer.start()
		else:
			fSwordAttackTimer.stop()

func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		if !area.get("experience") == null:
			var gem_exp = area.collect()
			calculate_experience(gem_exp*(1+exp_bonus))
		if !area.get("healing") == null:
			var food_healing = area.collect()
			heal(food_healing)
		if !area.get("cd_reduction") == null:
			var cd_reduction = area.collect()
			if !ultTimer.is_stopped():
				var max_red = ult_cd * cd_reduction
				var redux = min(ultTimer.time_left, max_red)
				ultTimer.start(ultTimer.time_left - redux+1)
		if !area.get("magnet_range") == null:
			area.collect()
			var loots = loot_base.get_children()
			for loot in loots:
				loot.target = self

func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap = 100 + (experience_level-19)*13
	else:
		exp_cap = 260 + (experience_level-39)*25
		
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func ultimate():
	$light/AnimationPlayer.play("flicker")
	ultActiavte.set_collision_layer_value(3,true)
	if scythe_on == true:
		var new_scythe = scythe.instantiate()
		new_scythe.global_position = global_position
		add_child(new_scythe)
		new_scythe.global_position = global_position
		$ult_snd_bell.play()
	if eye_on == true:
		var new_eye = eye.instantiate()
		screen_size = get_viewport_rect().size
		new_eye.position.x = -2
		new_eye.position.y = -27
		crit_chance = 0.5
		add_child(new_eye)
		$ult_snd_bell.play()
	ultDuration.start()
	ultRun.start()

func _on_activation_time_timeout():
	ultActiavte.set_collision_layer_value(3,false)
	ultRun.wait_time = 0.1

func _on_sword_timer_timeout():
	var sword_attack = sword.instantiate()
	sword_attack.position = position
	sword_attack.flipped = false
	match sprite.flip_h:
		true:
			sword_attack.last_movement = Vector2.LEFT
		false:
			sword_attack.last_movement = Vector2.RIGHT
	sword_attack.level = sword_level
	add_child(sword_attack)

func _on_sword_attack_timer_timeout():
	var sword_attack = sword.instantiate()
	sword_attack.position = position
	sword_attack.flipped = true
	match sprite.flip_h:
		true:
			sword_attack.last_movement = Vector2.RIGHT
		false:
			sword_attack.last_movement = Vector2.LEFT
	sword_attack.level = sword_level
	add_child(sword_attack)
	

func levelup():
	sndLevelUp.play()
	lblLevel.text = str("Level: ",experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel,"position",Vector2(220,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	#LevelUp Boosts:
	movement_speed += 0.5
	maxhp += 0.8
	if experience_level % 15 == 0:
		max_weapon_count+=1
	var options = 0
	var optionsmax = 3
	if experience_level == 10:
		$GUILayer/GUI/LevelUp/lbl_LevelUp.text = "Choose an Ultimate Ability:"
		optionsmax = 2
	else:
		$GUILayer/GUI/LevelUp/lbl_LevelUp.text = "Level Up !"
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true
 
func upgrade_character(upgrade):
	match upgrade:
		"hsword1":
			sword_level = 1
			sword_baseammo += 1
			weapon_count += 1
		"hsword2":
			sword_level = 2
			sword_attackspeed -= 2
		"hsword3":
			sword_level = 3
		"hsword4":
			sword_level = 4
			sword_attackspeed -= 2
		"hsword5":
			sword_level = 5
		"bow1":
			bow_level = 1
			bow_ammo += 1
			weapon_count+=1
		"bow2":
			bow_level = 2
			bow_ammo += 1
		"bow3":
			bow_level = 3
			bow_ammo += 1
		"bow4":
			bow_level = 4
			bow_ammo += 1
		"bow5":
			bow_level = 5
		"trail1":
			trail_level = 1
			weapon_count += 1
		"trail2":
			trail_level = 2
		"trail3":
			trail_level = 3
		"trail4":
			trail_level = 4
		"comet1":
			comet_level = 1
			comet_baseammo += 1
			weapon_count += 1
		"comet2":
			comet_level = 2
		"comet3":
			comet_level = 3
			comet_baseammo += 1
		"comet4":
			comet_level = 4
			comet_baseammo += 1
		"fsword1":
			fsword_level = 1
			fsword_baseammo += 1
			weapon_count += 1
		"fsword2":
			fsword_level = 2
			fsword_baseammo += 1
		"fsword3":
			fsword_level = 3
			fsword_attackspeed -= 0.3
		"fsword4":
			fsword_level = 4
			fsword_attackspeed -= 0.3
		"fsword5":
			fsword_level = 5
		"katana1":
			katana_level = 1
			katana_baseammo += 1
			weapon_count += 1
		"katana2":
			katana_level = 2
		"katana3":
			katana_level = 3
		"katana4":
			katana_level = 4
		"katana5":
			katana_level = 5
		"firegun1":
			firegun_level = 1
			firegun_baseammo += 1
			weapon_count += 1
		"firegun2":
			firegun_level = 2
			firegun_attackspeed -= 1
		"firegun3":
			firegun_level = 3
		"firegun4":
			firegun_level = 4
			firegun_baseammo += 1
		"firegun5":
			firegun_level = 5
			firegun_attackspeed -= 1
		"circle1":
			hell_circle_level = 1
			weapon_count += 1
		"circle2":
			hell_circle_level = 2
		"circle3":
			hell_circle_level = 3
		"circle4":
			hell_circle_level = 4
		"circle5":
			hell_circle_level = 5
		"icespear1":
			icespear_level = 1
			icespear_baseammo += 1
			weapon_count += 1
		"icespear2":
			icespear_level = 2
			icespear_baseammo += 1
			icespear_additional_ammo += 1
		"icespear3":
			icespear_level = 3
		"icespear4":
			icespear_level = 4
			icespear_baseammo += 2
		"icespear5":
			icespear_level = 5
			icespear_additional_ammo += 1
		"tornado1":
			tornado_level = 1
			tornado_baseammo += 1
			weapon_count += 1
		"tornado2":
			tornado_level = 2
			tornado_baseammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attackspeed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_baseammo += 1
		"tornado5":
			tornado_level = 5
		"javelin1":
			javelin_level = 1
			javelin_ammo = 1
			weapon_count += 1
		"javelin2":
			javelin_level = 2
		"javelin3":
			javelin_level = 3
		"javelin4":
			javelin_level = 4
		"javelin5":
			javelin_level = 5
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"grail1","grail2","grail3","grail4":
			damage_bonus += 0.1
		"diamond1","diamond2","diamond3","diamond4":
			exp_bonus+= 0.05
		"muscle1","muscle2","muscle3","muscle4":
			maxhp += 8
			heal(8)
		"compass1","compass2","compass3","compass4":
			collect_area.scale += Vector2(0.15,0.15)
		"bullet1","bullet2","bullet4","bullet5":
			speed_bonus += 0.1
		"ring1","ring2":
			additional_attacks += 1
		"food":
			heal(20)
		"scythe":
			scythe_on = true
		"eye":
			eye_on = true
	attack()
	adjust_gui_collection(upgrade)
	var option_children = upgradeOptions.get_children()
	while option_children.size()>0:
		var option = option_children.pop_front()
		option.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)

func get_random_item():
	var dblist = []
	if experience_level!=10:
		for i in UpgradeDb.UPGRADES:
			if i in collected_upgrades: #Find already collected upgrades
				pass
			elif i in upgrade_options: #If the upgrade is already an option
				pass
			elif UpgradeDb.UPGRADES[i]["type"] == "item": #Don't pick food
				pass
			elif UpgradeDb.UPGRADES[i]["type"] == "ultimate": #Don't pick ult
				pass
			elif UpgradeDb.UPGRADES[i]["type"] == "weapon" and weapon_count>=max_weapon_count: #Cap number of weapons
				pass
			elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #Check for PreRequisites
				var to_add = true
				for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
					if not n in collected_upgrades:
						to_add = false
				if to_add:
					dblist.append(i)
			else:
				dblist.append(i)
	else:
		for i in UpgradeDb.UPGRADES:
			if i in upgrade_options: #If the upgrade is already an option
				pass
			elif UpgradeDb.UPGRADES[i]["type"] == "ultimate":
				dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null

func _on_ult_duration_timeout():
	crit_chance = 0.1

func change_time(argtime = 0, boss = null, boss_max_hp = 0):
	$GUILayer/GUI/lbl_fps.text = str("fps:", Engine.get_frames_per_second()," kills:", HelperManager.enemies_killed, " rev%: ", HelperManager.chance)
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0,get_m)
	if get_s < 10:
		get_s = str(0,get_s)
	lblTimer.text = str(get_m,":",get_s)
	if time == end_time-120:
		$"weather manager/rain".emitting = false
		$light.update(2.5)
	if time == end_time-5:
		bgm.stream_paused = true
		$"weather manager/ash".emitting = true
		$light.update(1)
	if time == end_time+2:
		boss_bgm.playing = true
	if time == end_time+4:
		bossHealthBar.visible = true
		$light.update(4)
		var tween = bossHealthBar.create_tween()
		tween.tween_property(bossHealthBar, "modulate", Color(1, 1, 1, 1),4).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.play()
	if time == end_time+12:
		funny_timer.start()
	if boss != null and final_boss == null:
		final_boss = boss
		final_boss_hp = boss_max_hp

func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)

func death():
	lblstagger.visible = false
	deathPanel.visible = true
	emit_signal("playerdeath")
	get_tree().paused = true
	bgm.stream_paused = true
	boss_bgm.stream_paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel,"position",Vector2(220,55),3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if boss_flag == 1:
		boss_flag = 0
		lblResult.text = "Victory !"
		sndVictoryBoss.play()
	elif time >= end_time:
		lblResult.text = "You Survived...\nBut The Boss Isn't Dead !"
		sndVictory.play()
	else:
		lblResult.text = "You Lose !"
		sndLose.play()

func _on_btn_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")

func _on_btn_quit_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")

func _on_btn_resume_click_end():
	var tween = pausePanel.create_tween()
	tween.tween_property(pausePanel,"position",Vector2(-260,55),1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	get_tree().paused = false

func _on_magnet_timer_timeout():
	collect_area.scale = Vector2(1,1)

func _on_shift_timer_timeout():
	var bckgrnd_sprite = backgrnd.get_child(0)
	shift_mod += 3
	shift_mod = fmod(shift_mod,10)
	var color = shift_mod/10
	bckgrnd_sprite.modulate = Color.from_hsv(color,0.65,1)

func heal(healing):
	hp += healing
	var number = dmg_num.instantiate()
	add_child(number)
	number.position = position
	number.label.text = str(int(healing))
	number.modulate = Color(0,0.75,0.4,0.6)
	hp = clamp(hp,0,maxhp)
	if hp>maxhp*10/100:
		near_death = false
	healthBar.max_value = maxhp
	healthBar.value = hp

func _on_comet_timer_timeout():
	comet_ammo += comet_baseammo + additional_attacks
	cometAttackTimer.start()

func _on_comet_attack_timer_timeout():
		if comet_ammo > 0:
			var comet_attack = comet.instantiate()
			var target = Vector2.ZERO
			target.x = randf_range(global_position.x-(screen_size.x/2)+100, global_position.x+(screen_size.x/2)-100)
			target.y = randf_range(global_position.y-(screen_size.y/2)+50, global_position.y+(screen_size.y/2)-50)
			comet_attack.target = target
			comet_attack.position.x = target.x
			comet_attack.position.y = target.y -screen_size.y
			comet_attack.level = comet_level
			add_child(comet_attack)
			comet_ammo -= 1
			if comet_ammo > 0:
				cometAttackTimer.start()
			else:
				cometAttackTimer.stop()

func _on_shotgun_timer_timeout():
	firegun_ammo += firegun_baseammo + additional_attacks
	firegunAttackTimer.start()

func _on_shotgun_attack_timer_timeout():
	if firegun_ammo > 0:
		var last_mov = last_movement.normalized()
		
		var firegun_attack1 = fire_bullet.instantiate()
		firegun_attack1.position = position
		firegun_attack1.angle = last_mov
		firegun_attack1.level = firegun_level
		firegun_attack1.light_on = true
		add_child(firegun_attack1)
		
		var firegun_attack2 = fire_bullet.instantiate()
		firegun_attack2.position = position
		firegun_attack2.angle =  last_mov.rotated(deg_to_rad(-5))
		firegun_attack2.level = firegun_level
		add_child(firegun_attack2)
		
		var firegun_attack3 = fire_bullet.instantiate()
		firegun_attack3.position = position
		firegun_attack3.angle = last_mov.rotated(deg_to_rad(5))
		firegun_attack3.level = firegun_level
		add_child(firegun_attack3)
		
		if firegun_level >= 5:
			var firegun_attack4 = fire_bullet.instantiate()
			firegun_attack4.position = position
			firegun_attack4.angle =  last_mov.rotated(deg_to_rad(-10))
			firegun_attack4.level = firegun_level
			add_child(firegun_attack4)
		
			var firegun_attack5 = fire_bullet.instantiate()
			firegun_attack5.position = position
			firegun_attack5.angle = last_mov.rotated(deg_to_rad(10))
			firegun_attack5.level = firegun_level
			add_child(firegun_attack5)
		
		snd_shot.play()
		firegun_ammo -= 1
		if firegun_ammo > 0:
			firegunAttackTimer.start()
		else:
			firegunAttackTimer.stop()

func _on_katana_timer_timeout():
	katana_ammo += katana_baseammo + additional_attacks
	katanaAttackTimer.start()

func _on_katana_attack_timer_timeout():
	if katana_ammo > 0:
		var new_katana = katana.instantiate()
		new_katana.position = position
		new_katana.level = katana_level
		add_child(new_katana)
		katana_ammo-=1
		if katana_ammo > 0:
			katanaAttackTimer.start()
		else:
			katanaAttackTimer.stop()

func _on_shadow_timer_timeout():
	if velocity != Vector2.ZERO:
		var new_shadow = shadow.instantiate()
		new_shadow.position = position
		new_shadow.texture = sprite.texture
		new_shadow.hframes = sprite.hframes
		new_shadow.vframes = sprite.vframes
		new_shadow.frame = sprite.frame
		new_shadow.flip_h = sprite.flip_h
		get_tree().current_scene.add_child(new_shadow)

func _on_weapon_update_timeout():
	if javelin_level > 0:
		spawn_javelin()
	if hell_circle_level > 0:
		update_hell()

func update_hell():
	var circles = hell_base
	if circles.size() > 0:
		for circle in circles:
			if circle.has_method("update"):
				circle.level = hell_circle_level
				circle.global_position = global_position
				circle.update()
	else:
		var circle = hell_circle.instantiate()
		circle.global_position = global_position
		hell_base.append(circle)
		add_child(circle)
		update_hell()

func _on_boss_death_timer_timeout():
	death()

func _on_trail_timer_timeout():
	var new_fire = fire_trail.instantiate()
	new_fire.level = trail_level
	new_fire.position = position
	if $Attack/TrailSndTimer.is_stopped():
		$Attack/snd_trail.play()
		$Attack/TrailSndTimer.start()
	add_child(new_fire)

func _on_bow_timer_timeout():
	var new_bow = bow.instantiate()
	new_bow.level = bow_level
	new_bow.ammo = bow_ammo + additional_attacks
	new_bow.angle = last_movement.normalized()
	add_child(new_bow)
	if bow_level == 5:
		var new_bow2 = bow.instantiate()
		new_bow2.level = bow_level
		new_bow2.ammo = bow_ammo + additional_attacks
		new_bow2.angle = -last_movement.normalized()
		new_bow2.flipped = true
		add_child(new_bow2)


func _on_vuln_timer_timeout():
	var tween = lblHelp.create_tween()
	invul = false
	ultActiavte.knockback_amount = 400
	tween.tween_property(lblHelp,"modulate", Color(1,1,1,0), 2)
	tween.play()


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
