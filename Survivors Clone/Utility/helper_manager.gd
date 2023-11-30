extends Node

@onready var base_chance = 5.0
@onready var enemies_killed = 0
@onready var chance = 5.0
@onready var chance_increase_per_kill = 0.5
@onready var base_cd = 90.0
@onready var player = get_tree().get_first_node_in_group("player")
@onready var cd = $HelpCD

func _ready():
	chance = base_chance
	enemies_killed = 0
	chance_increase_per_kill = 0.5
	cd.wait_time = base_cd

func killed():
	enemies_killed += 1
	chance += chance_increase_per_kill
	chance = clamp(chance, 5.0, 100.0)

func assisted():
	chance_increase_per_kill /= 2
	chance_increase_per_kill = clamp(chance_increase_per_kill, 0.02, 1.0)
	chance = base_chance
	cd.wait_time = base_cd
	cd.start()

