extends ColorRect

@onready var label = $RichTextLabel

func _ready():
	AudioManager.play_sound("aura-horizon", true)

func _process(delta):
	label.position.y -= (250 if Input.is_action_pressed("down") else 50) * delta
	if label.position.y < -850:
		$Timer.start()
		set_process(false)

func _on_timer_timeout():
	SceneManager.change_scene("res://scenes/menu.tscn")
