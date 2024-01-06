extends Node2D

var camera: Camera2D
var music_player: AudioStreamPlayer2D

func _ready():
	camera = get_viewport().get_camera_2d()

func _process(delta):
	if not camera: camera = get_viewport().get_camera_2d()
	if camera and music_player:
		music_player.position = camera.position

func play_sound(file_name, is_music = false):
	var path = "res://audio/" + file_name + ".%s" % ("mp3" if is_music else "wav")
	var stream = load(path)
	
	if !is_music:
		var stream_player = AudioStreamPlayer2D.new()
		stream_player.stream = stream
		stream_player.pitch_scale = randf_range(1, 2)
		
		if camera: camera.call_deferred("add_child", stream_player)
		else: call_deferred("add_child", stream_player)
		
		stream_player.call_deferred("play")
		await stream_player.finished
		stream_player.queue_free()
	else:
		if music_player == null:
			music_player = AudioStreamPlayer2D.new()
			music_player.volume_db = -25
			add_child(music_player)
		else:
			var tween = create_tween()
			tween.tween_property(music_player, "volume_db", -25, .5)
			await tween.finished
			music_player.stop()
		music_player.stream = stream
		music_player.play()
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", 0, .5)
