extends PlayerState

func enter(msg = {}):
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
		player.player_sprite.play("jump")

func physics_update(delta: float):
	var input_direction_x: float = (
		Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left")
	)
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("DashState", {do_dash = true})

	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
	
	if Input.is_action_just_pressed("attack") and Input.is_action_pressed("ui_down"):
		state_machine.transition_to("Attack", {do_down_slash = true})
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack", {do_forward_slash = true})
