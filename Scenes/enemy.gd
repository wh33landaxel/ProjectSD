extends CharacterBody2D

enum states {PATROL, CHASE, ATTACK, DEAD}

var anim_state
var run_speed = 100
var player = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player: 
		velocity = Vector2(position.direction_to(player.position).x * run_speed, 0)
	move_and_slide()


func _on_detection_radius_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_detection_radius_body_exited(body):
	player = null
