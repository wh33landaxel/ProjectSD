extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var raycast = $Sprite2D/RayCast2D
@onready var sprite = $Sprite2D
@onready var line = $Sprite2D/Line2D
@export var flip_h = false
var alert = preload("res://Scenes/alert.tscn")

signal camera_alert
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("surveillance")
	self.scale.x = -1 if flip_h else 1
	Global.alert_changed.connect(alert_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if raycast.is_colliding():
		var collider = raycast.get_collider()  
		if collider.is_in_group("player") and Global.alert_mode != Global.ALERT_MODES.ALERT_ON:
			Global.alert_mode = Global.ALERT_MODES.ALERT_ON

func alert_changed(alert_mode: Global.ALERT_MODES):
	if alert_mode == Global.ALERT_MODES.ALERT_ON:
		_camera_enabled(false)
		spawn_alert()
	else:
		_camera_enabled(true)
		
func _camera_enabled(enabled: bool):
	line.visible = enabled
	raycast.collide_with_bodies = enabled

func spawn_alert(): 
	var a = alert.instantiate()
	a.position = position
	add_child(a)
	print("spawning alert")
	
