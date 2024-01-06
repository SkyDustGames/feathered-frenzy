extends Area2D

@onready var weapon_shop = $"../../CanvasLayer/WeaponShopUI"
var can_open = false
var player = null

func _input(event):
	if event.is_action_pressed("switch_weapon") and can_open:
		if player: player.can_shoot = weapon_shop.visible
		if weapon_shop.visible: weapon_shop.hide()
		else: weapon_shop.show()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		can_open = true
		$Popup.show()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player = null
		can_open = false
		$Popup.hide()
