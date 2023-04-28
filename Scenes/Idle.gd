extends PlayerState

func enter(_msg = {}):
	player.velocity = Vector2.ZERO
	
func physics_update(_delta: float):
	if not player.is_on_floor():
		print("air")
		state_machine.transition_to("Air")
		return
	
	player.player_sprite.play("idle")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", { do_jump = true })
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.transition_to("Walk")
	elif Input.is_action_just_pressed("attack") and Input.is_action_pressed("ui_down"):
		state_machine.transition_to("Attack", {do_down_slash = true})
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack", {do_forward_slash = true})

