extends CharacterBody2D

const DEFAULT_SPEED = 300.0
const RUN_SPEED = 400
const DASH_SPEED = 600.0
const JUMP_VELOCITY = -400.0
const PUSHBACK_FORCE = 50

signal player_ded

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_facing_right = true
var dead = false
var dash_duration = 0.2
var can_run = false
var is_running = false
var speed = 300.0
var run_timer = null
var buffer_time = 0.2
const BOUNCE_VELOCITY = 500

@onready var animation_player = $AnimationPlayer
@onready var dash = $Dash
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	run_timer = Timer.new()
	run_timer.wait_time = buffer_time
	add_child(run_timer)
	run_timer.connect("timeout", _on_run_timer_timeout)
	Global.player = self
	animated_sprite.connect("frame_changed", attempt_play_footstep)
	
func _physics_process(delta):
	
	if dead:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#Handle Dash
	if Input.is_action_just_pressed("dash") and dash.can_dash:
		dash.start_dash(animated_sprite, dash_duration)
		$DashPlayer.play()
	
	if Input.is_action_pressed("ui_right"):
		if can_run:
			is_running = true
		else:
			is_running = false

	if Input.is_action_just_pressed("ui_right"):
		if can_run == false: 
			run_timer.start()
	
	if Input.is_action_just_released("ui_right"):
		if !run_timer.is_stopped():
			can_run = true
		else:
			can_run = false
		
	
	if dash.is_dashing():
		speed = DASH_SPEED
	elif is_running:
		speed = RUN_SPEED
	else:
		speed = DEFAULT_SPEED

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")
	
	if Input.is_action_just_pressed("attack"):
		$AnimatedSprite2D.play("char_slash")
		$SlashPlayer.play()
		if Input.is_action_pressed("ui_down"):
			animation_player.play("down_slash")
		else:
			$AnimatedSprite2D.play("char_slash")
			animation_player.play("slash")
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var move_direction = get_move_direction()
	if move_direction:
		velocity.x = move_direction.x * speed
		if dash.is_dashing():
			velocity.y = move_direction.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
	if is_on_floor() and velocity.x != 0:
		$AnimatedSprite2D.play("walking")
	
	if is_on_floor() and velocity.x == 0:
		$AnimatedSprite2D.play("idle")

	if is_on_floor():
		if velocity.x > 0 and not is_facing_right:
			flip()
		elif velocity.x < 0 and is_facing_right:
			flip()
			
#Gets moving direction for all axes
func get_move_direction():
	return Vector2(
		int(Input.is_action_pressed('ui_right')) - int(Input.is_action_pressed('ui_left')),
		int(Input.is_action_pressed('ui_down')) - int(Input.is_action_pressed('ui_up'))
	)
	
func attempt_play_footstep():
	if animated_sprite.animation == "walking" and animated_sprite.frame == 1 or animated_sprite.frame == 3:
		play_footstep()

func play_footstep():
	$FootStepPlayer.play_step()

func flip():
	is_facing_right = !is_facing_right
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	$SlashSprite.flip_h = !$SlashSprite.flip_h
	$SlashSprite.position.x = -$SlashSprite.position.x

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false	
	$AnimatedSprite2D.play("idle")
	dead = false 

func kill():
	dead = true
	emit_signal("player_ded")
	$AnimatedSprite2D.play("die")
	$ExplosionSound.play()
	
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "die":
		$CollisionShape2D.disabled = true
		hide()
		

func _on_weapon_collision_body_entered(body):
	if body.is_in_group("enemy"):
		var direction = (body.position - position).normalized()
		var impulse = Vector2(direction.x * PUSHBACK_FORCE, 0)
		body.move_and_collide(impulse)
	if body.is_in_group("eye_bot"):
		if get_tree().get_nodes_in_group("dash_ghost").size() > 0:
			print("slash dash")
			dash.can_dash = true

func _on_dash_ended():
	velocity.y = 0

func _on_run_timer_timeout():
	if !Input.is_action_pressed("ui_right"):
		can_run = false


func _on_down_weapon_collision_body_entered(body):
# Calculate the direction of the bounce
	var bounce_direction = position - body.global_position
	
	# Apply the bounce velocity in the opposite direction of the enemy
	velocity = bounce_direction.normalized() * BOUNCE_VELOCITY
	
	# Move the player to avoid colliding with the enemy again
	move_and_slide()

