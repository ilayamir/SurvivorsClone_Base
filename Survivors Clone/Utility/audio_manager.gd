extends Node

@onready var gem_collect_snd = get_node("%snd_collected")
@onready var enemy_hit_snd = get_node("%snd_hit")
@onready var enemy_death_snd = get_node("%snd_explosion")
@onready var crit_snd = get_node("%snd_crit")

var num_players = 6
var max_queue = 4
var available_collect = []
var available_death = []
var available_hit = []
var available_crit = []
var collect_queue = 0
var death_queue = []
var hit_queue = []
var crit_queue = []

func _ready():
	for num in num_players:
		var new_collect = gem_collect_snd.duplicate()
		var new_death = enemy_death_snd.duplicate()
		var new_hit = enemy_hit_snd.duplicate()
		var new_crit = crit_snd.duplicate()
		add_child(new_collect)
		add_child(new_death)
		add_child(new_hit)
		add_child(new_crit)
		available_collect.append(new_collect)
		available_death.append(new_death)
		available_hit.append(new_hit)
		available_crit.append(new_crit)
		new_collect.finished.connect(_on_stream_finished.bind("collect",new_collect))
		new_death.finished.connect(_on_stream_finished.bind("death",new_death))
		new_hit.finished.connect(_on_stream_finished.bind("hit",new_hit))
		new_crit.finished.connect(_on_stream_finished.bind("crit",new_crit))
		

func _on_stream_finished(sound, stream):
	if sound == "collect":
		available_collect.append(stream)
	elif sound == "death":
		available_death.append(stream)
	elif sound == "hit":
		available_hit.append(stream)
	elif sound == "crit":
		available_crit.append(stream)

func _physics_process(_delta):
	if not collect_queue==0 and not available_collect.is_empty():
		collect_queue -= 1
		var player = available_collect.pop_front()
		player.play()
	if not hit_queue.is_empty() and not available_hit.is_empty():
		var pos = hit_queue.pop_front()
		var player = available_hit.pop_front()
		player.global_position = pos
		player.play()
	if not death_queue.is_empty() and not available_death.is_empty():
		var pos = death_queue.pop_front()
		var player = available_death.pop_front()
		player.global_position = pos
		player.play()
	if not crit_queue.is_empty() and not available_crit.is_empty():
		var pos = crit_queue.pop_front()
		var player = available_crit.pop_front()
		player.global_position = pos
		player.play()


func play_collect():
	if collect_queue < max_queue:
		if $gem_delay.is_stopped():
			collect_queue+=1
			$gem_delay.start()

func play_positional(sound, position):
	if sound == "hit" and hit_queue.size()<max_queue:
		if $hit_delay.is_stopped():
			hit_queue.append(position)
			$hit_delay.start()
	if sound == "death" and death_queue.size()<max_queue:
		if $death_delay.is_stopped():
			death_queue.append(position)
			$death_delay.start()
	if sound == "crit" and crit_queue.size()<max_queue:
		if $crit_delay.is_stopped():
			crit_queue.append(position)
			$crit_delay.start()
