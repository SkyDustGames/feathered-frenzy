extends Node2D

@export var speed: float
@onready var bg1 = $BG1
@onready var bg2 = $BG2

func _process(delta):
	bg1.position.x -= delta * speed
	bg2.position.x -= delta * speed
	if bg1.position.x < -720: bg1.position.x = 700
	if bg2.position.x < -720: bg2.position.x = 700
