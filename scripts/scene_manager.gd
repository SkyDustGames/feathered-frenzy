extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play_backwards("fade")

func change_scene(path: String):
	animation_player.play("fade")
	var scene = load(path)
	get_tree().call_deferred("change_scene_to_packed", scene)
	animation_player.play_backwards("fade")

func reload_current_scene():
	animation_player.play("fade")
	get_tree().call_deferred("reload_current_scene")
	animation_player.play_backwards("fade")
