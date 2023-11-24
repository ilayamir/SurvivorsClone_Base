extends Area2D

@export var hp = 8
@export var dmg = 1
@export var spd = 0.2
@export var knockback_recovery = 3.5
@export var experience = 1

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var snd_hit = $snd_hit
@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")

var death_anim = preload("res://Enemy/explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")
var floor_meat = preload("res://Objects/floor_meat.tscn")
var ult_potion = preload("res://Objects/ult_potion.tscn")
var gem_magnet = preload("res://Objects/gem_magnet.tscn")

var knockback = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func  _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, 90)
	var direction = global_position.direction_to(player.global_position)
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false
	global_position += direction * spd
	global_position += knockback

func _on_area_entered(area):
	if area.is_in_group("attacks"):
		hp -= area.damage
		knockback = area.angle * area.knockback_amount
		if area.has_method("enemy_hit"):
			area.enemy_hit()
		if hp<0:
			death()
		snd_hit.play()
	
func death():
	var enemy_death = death_anim.instantiate()
	if self.is_in_group("boss"):
		enemy_death.boss = 1
	enemy_death.scale = sprite.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child",enemy_death)
	var gem_chance = randf_range(0,1)
	var food_chance = randf_range(0,1)
	var ult_chance = randf_range(0,1)
	var magnet_chance = randf_range(0,1)
	if gem_chance<0.6:
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
	if ult_chance<0.004:
		var new_ult = ult_potion.instantiate()
		new_ult.global_position = global_position - Vector2(5,5)
		loot_base.call_deferred("add_child",new_ult)
	if magnet_chance<0.005:
		var new_magnet = gem_magnet.instantiate()
		new_magnet.global_position = global_position - Vector2(-5,5)
		loot_base.call_deferred("add_child",new_magnet)
	queue_free()
