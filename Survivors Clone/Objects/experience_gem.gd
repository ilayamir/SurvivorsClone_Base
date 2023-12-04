extends Area2D

@export var experience = 1

var spr_green = preload("res://Textures/Items/Gems/Gem_green.png")
var spr_blue= preload("res://Textures/Items/Gems/Gem_blue.png")
var spr_red = preload("res://Textures/Items/Gems/Gem_red.png")

var target = null
var speed = -1
var merging = false
var unmergeable = false

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spr_blue
	else:
		sprite.texture = spr_red

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collect():
	AudioManager.play_collect()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	queue_free()
	return experience


func _on_visible_on_screen_notifier_2d_screen_entered():
	sprite.visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	sprite.visible = false


func _on_area_entered(area):
	if area.get("experience"): 
		if !merging and !area.merging and !unmergeable and !area.unmergeable:
			area.merging = true
			experience += area.experience
			area.queue_free()
			merging = true
			call_deferred("reset_merging")

func reset_merging():
	merging = false
