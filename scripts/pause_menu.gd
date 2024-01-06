extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		$PauseMenu.show()
	else:
		$PauseMenu.hide()

func start():
	toggle_pause()
	SceneManager.change_scene("res://scenes/menu.tscn")

func restart():
	toggle_pause()
	SceneManager.reload_current_scene()
