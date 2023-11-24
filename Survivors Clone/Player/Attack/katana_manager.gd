extends Node2D

var level = 0
@onready var anim = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var blades = [$Katana,$Katana2,$Katana3,$Katana4,$Katana5,$Katana6,$Katana7,$Katana8]
@onready var base_blades = [[$Katana,$Katana5],[$Katana3,$Katana7]]

# Called when the node enters the scene tree for the first time.
func _ready():
	update_blades()
	anim.play("slice")
	$Katana8.angle = Vector2(0,-1)
	$Katana.angle = Vector2(1,-1).normalized()
	$Katana2.angle = Vector2(1,0)
	$Katana3.angle = Vector2(1,1).normalized()
	$Katana4.angle = Vector2(0,1)
	$Katana5.angle = Vector2(-1,1).normalized()
	$Katana6.angle = Vector2(-1,0)
	$Katana7.angle = Vector2(-1,-1).normalized()
	
	match level:
		1:
			var katanas = base_blades.pick_random()
			var katana = katanas.pick_random()
			katana.process_mode = Node.PROCESS_MODE_INHERIT
			katana.visible = true
		2,3:
			var katanas = base_blades.pick_random()
			for katana in katanas:
				katana.process_mode = Node.PROCESS_MODE_INHERIT
				katana.visible = true
		4:
			for pack in base_blades:
				for katana in pack:
					katana.process_mode = Node.PROCESS_MODE_INHERIT
					katana.visible = true
			
		5:
			for blade in blades:
				blade.process_mode = Node.PROCESS_MODE_INHERIT
				blade.visible = true


func _physics_process(_delta):
	self.position = player.global_position


func _on_animation_player_animation_finished(_slice):
	for blade in blades:
		blade.emit_signal("remove_from_array",blade)
		blade.queue_free()
	queue_free()

func update_blades():
	for blade in blades:
		blade.level = level
		blade._ready()
