extends Area2D

@onready var anim_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("alert_appeared")


func _on_body_entered(body):
	pass
