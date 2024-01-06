extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.health += 1
		body.health_label.text = str(body.health)
		AudioManager.play_sound("pickupCoin")
		queue_free()
