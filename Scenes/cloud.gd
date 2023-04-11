extends Node2D

@export var CLOUD_ACCEL = 200
var moving = false
var moving_right = false
var x_loc = 0
var rain_drop = preload("res://Scenes/rain_drop.tscn")

func _ready():
	x_loc = position.x

func _physics_process(delta):
	if moving:
		if moving_right:
			translate(Vector2(CLOUD_ACCEL, 0) * delta)
		else:
			translate(Vector2(-CLOUD_ACCEL, 0) * delta)

func _on_rain_timer_timeout():
	var r = rain_drop.instantiate()
	add_child(r)
	

