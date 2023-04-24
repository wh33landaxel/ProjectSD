class_name Player

extends CharacterBody2D

enum States {ON_GROUND, IN_AIR, DASHING}

signal player_ded

const BOUNCE_VELOCITY = 500
const DASH_SPEED = 600.0
const DEFAULT_SPEED = 300.0
const JUMP_VELOCITY = -400.0
const PUSHBACK_FORCE = 50

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_facing_right = true
var dead = false
var dash_duration = 0.2
var speed = 300.0

@onready var animation_player = $AnimationPlayer
@onready var dash = $Dash
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var forward_slash_sprite = $SlashSprite

func _ready():
	Global.player = self
	player_sprite.connect("frame_changed", attempt_play_footstep)
	
func _physics_process(delta):
	
	#If you dead, you dead
	if dead:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#Handle Dash
	if Input.is_action_just_pressed("dash") and dash.can_dash:
		dash.start_dash(player_sprite, dash_duration)
		$DashPlayer.play()
	
	speed = DASH_SPEED if dash.is_dashing() else DEFAULT_SPEED
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		player_sprite.play("jump")
	
	#Attack Slash
	if Input.is_action_just_pressed("attack"):
		player_sprite.play("char_slash")
		$SlashPlayer.play()
		if Input.is_action_pressed("ui_down") and not animation_player.current_animation == "down_slash":
			animation_player.play("down_slash")
		else:
			animation_player.play("slash")
		
	# Move direction with velocity	
	var move_direction = get_move_direction()
	if move_direction:
		velocity.x = move_direction.x * speed
		if dash.is_dashing():
			velocity.y = move_direction.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
	#Sprite Animations
	if is_on_floor() and velocity.x != 0:
		player_sprite.play("walking")
	
	if is_on_floor() and velocity.x == 0:
		player_sprite.play("idle")

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
	if player_sprite.animation == "walking" and player_sprite.frame == 1 or player_sprite.frame == 3:
		play_footstep()

func play_footstep():
	$FootStepPlayer.play_step()

func flip():
	is_facing_right = !is_facing_right
	player_sprite.flip_h = !player_sprite.flip_h
	forward_slash_sprite.flip_h = !forward_slash_sprite.flip_h
	forward_slash_sprite.position.x = -forward_slash_sprite.position.x

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false	
	player_sprite.play("idle")
	dead = false 

func kill():
	dead = true
	emit_signal("player_ded")
	player_sprite.play("die")
	$ExplosionSound.play()

	
func _on_animated_sprite_2d_animation_finished():
	if player_sprite.animation == "die":
		$CollisionShape2D.disabled = true
		hide()
		

func _on_weapon_collision_body_entered(body):
	print("on weapon body entered")
	if body.is_in_group("enemy"):
		var direction = (body.position - position).normalized()
		var impulse = Vector2(direction.x * PUSHBACK_FORCE, 0)
		body.move_and_collide(impulse)
	if body.is_in_group("eye_bot"):
		print("killed eye bot")
		if get_tree().get_nodes_in_group("dash_ghost").size() > 0:
			dash.can_dash = true

func _on_dash_ended():
	velocity.y = 0

#Bounce on enemy slash mechanic
func _on_down_weapon_collision_body_entered(body):
	# Calculate the direction of the bounce
	var bounce_direction = position - body.global_position
	
	# Apply the bounce velocity in the opposite direction of the enemy
	velocity = bounce_direction.normalized() * BOUNCE_VELOCITY
	
	# Move the player to avoid colliding with the enemy again
	move_and_slide()

