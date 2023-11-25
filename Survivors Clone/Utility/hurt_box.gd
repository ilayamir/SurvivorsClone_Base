extends Area2D

@export_enum("Cooldown","HitOnce", "DisableHitBox") var HurtBoxType = 0
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer
@onready var player = get_tree().get_first_node_in_group("player")
var dmg_num = preload("res://Utility/damage_number.tscn")

signal hurt(damage, angle, knockback, special_effect)
signal hurt_ult(damage, angle, knockback)

var crit = false
var hit_once_array = []
var hitbox = preload("res://Utility/hit_box.tscn")

func _on_area_entered(area):
	if area.is_in_group("attacks") or area.is_in_group("hitbox"):
		if not area.get("damage") == null:
			if area.is_in_group("cooldown_hurtbox_enforcers"):
				set_collision_mask_value(5,false)
				if area.get("cd"):
					disableTimer.start(area.cd)
				else:
					disableTimer.start(0.5)
			else:
				match HurtBoxType:
					0:
						collision.call_deferred("set", "disabled", true)
						disableTimer.start()
					1:
						if hit_once_array.has(area) == false:
							hit_once_array.append(area)
							if area.has_signal("remove_from_array"):
								if not area.is_connected("remove_from_array", Callable(self,"remove_from_list")):
									area.connect("remove_from_array", Callable(self,"remove_from_list"))
						else:
							return
					2:
						if area.has_method("tempdisable"):
							area.tempdisable()
			var damage = area.damage
			if get_parent().stagger:
				damage*=1.5
			var angle = Vector2.ZERO
			var knockback = 1
			if not area.get("angle") == null:
				angle = area.angle
			if area.is_in_group("aura"):
				angle = -global_position.direction_to(player.global_position)
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
			var crit_chance = randf_range(0,1)
			if crit_chance<player.crit_chance and area.is_in_group("attacks"):
				var crit_dmg = 1.5
				if get_parent().crit_vul == true:
					crit_dmg = 2.5
				damage = damage*crit_dmg
				crit = true
				AudioManager.play_positional("crit", global_position)
			else:
				damage = damage
				crit = false
			if area.is_in_group("attacks"):
				var number = dmg_num.instantiate()
				get_parent().get_parent().add_child(number)
				number.position = get_parent().position
				number.position.x += randi_range(-4,4)
				number.position.y += randi_range(-2,2)
				number.scale *= randf_range(0.9,1.2)
				if crit:
					number.label.text = str(int(damage)) + "!"
					number.scale *= 1.2
					number.modulate = Color(0.78,0.57,0.02,0.75)
				else:
					number.label.text = str(int(damage))
			var special_effect = "none"
			if area.get("special_effect"):
				special_effect = area.special_effect
			emit_signal("hurt", damage, angle, knockback, special_effect)
			if area.has_method("enemy_hit"):
				if get_parent().is_in_group("boss"):
					area.enemy_hit(100, crit)
				else:
					area.enemy_hit(1, crit)
	elif area.is_in_group("ultimate"):
		var damage = area.damage
		var angle = -global_position.direction_to(player.global_position)
		var knockback = 1
		if not area.get("knockback_amount") == null:
			knockback = area.knockback_amount
		emit_signal("hurt_ult", damage, angle, knockback)

func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

func _on_disable_timer_timeout():
	if get_parent() != player:
		set_collision_mask_value(5,true)
	collision.call_deferred("set", "disabled", false)
