extends ColorRect

func _ready():
	AudioManager.play_sound("starlight-city", true)

func main():
	$MainMenu.show()
	$AboutMenu.hide()
	AudioManager.play_sound("button")

func about():
	$AboutMenu.show()
	$MainMenu.hide()
	AudioManager.play_sound("button")

func start():
	SceneManager.change_scene("res://scenes/main_map.tscn")
	AudioManager.play_sound("button")
