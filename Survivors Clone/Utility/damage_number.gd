extends Node2D

@onready var label = $Label
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	fade()
	#timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_timer_timeout():
	queue_free()

func fade():
	var tween = label.create_tween()
	tween.tween_property(label,"modulate",Color(1,1,1,1),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if tween.is_running():
		tween.tween_property(label,"modulate",Color(1,1,1,0),0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.play()
	timer.start()
