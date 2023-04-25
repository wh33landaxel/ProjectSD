extends PlayerState

func enter(msg = {}):
	print("connected")
	if !player.player_sprite.is_connected("frame_changed", attempt_play_footstep):
		player.player_sprite.connect("frame_changed", attempt_play_footstep)

func physics_update(_delta: float):
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	player.speed = player.DEFAULT_SPEED
	player.player_sprite.play("walking")
	# Move direction with velocity	
	var move_direction = get_move_direction()
	if move_direction:
		player.velocity.x = move_direction.x * player.speed
		#TODO: Need to figure out dash mechanic
		#if player.dash.is_dashing():
			#player.velocity.y = move_direction.y * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	
	player.move_and_slide()
	
	if player.is_on_floor():
		if player.velocity.x > 0 and not player.is_facing_right:
			player.flip()
		elif player.velocity.x < 0 and player.is_facing_right:
			player.flip()
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("DashState", {do_dash = true})
	elif is_equal_approx(move_direction.x, 0.0):
		state_machine.transition_to("Idle")

#Gets moving direction for all axes
func get_move_direction():
	return Vector2(
		int(Input.is_action_pressed('ui_right')) - int(Input.is_action_pressed('ui_left')),
		int(Input.is_action_pressed('ui_down')) - int(Input.is_action_pressed('ui_up'))
	)
	
func attempt_play_footstep():
	if player.player_sprite.animation == "walking" and player.player_sprite.frame == 1 or player.player_sprite.frame == 3:
		play_footstep()

func play_footstep():
	player.footstep_player.play_step()
