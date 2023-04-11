extends Area2D

var down_dir = Vector2.DOWN
var rain_accel = 200

func _ready():
	$RainAnimationSprite.play()

func _physics_process(delta):
	translate(down_dir  * rain_accel * delta)


func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_ded")
		body.kill()
