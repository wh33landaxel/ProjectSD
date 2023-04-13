extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var raycast = $Sprite2D/RayCast2D
@onready var sprite = $Sprite2D
@onready var line = $Sprite2D/Line2D
@export var flip_h = false

signal camera_alert
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("surveillance")
	self.scale.x = -1 if flip_h else 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if raycast.is_colliding():
		var collider = raycast.get_collider()  
		if collider.is_in_group("player"):
			emit_signal("camera_alert")
