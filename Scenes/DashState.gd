extends PlayerState

func enter(msg = {}):
	if msg.has("do_dash"):
		player.dash.start_dash(player.player_sprite, player.dash_duration)
		player.dash_player.play()

func physics_update(delta: float):
	
	player.speed = player.DASH_SPEED
	var move_direction = get_move_direction()
	if move_direction:
		player.velocity.x = move_direction.x * player.speed
		if player.dash.is_dashing():
			player.velocity.y = move_direction.y * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	
	player.move_and_slide()

#Gets moving direction for all axes
func get_move_direction():
	return Vector2(
		int(Input.is_action_pressed('ui_right')) - int(Input.is_action_pressed('ui_left')),
		int(Input.is_action_pressed('ui_down')) - int(Input.is_action_pressed('ui_up'))
	)

func _on_dash_ended():
	
	player.velocity.y = 0
	player.speed = player.DEFAULT_SPEED
	
	if !player.is_on_floor():
		state_machine.transition_to("Air")
	elif player.is_on_floor() and is_equal_approx(player.velocity.x, 0.0):
		state_machine.transition_to("Walk")
	else: 
		state_machine.transition_to("Idle")

