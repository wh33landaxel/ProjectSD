extends PlayerState

@export_node_path("AnimationPlayer") var _animation_player
@export_node_path("AudioStreamPlayer2D") var _slash_audio_player
@onready var animation_player: AnimationPlayer = get_node(_animation_player)
@onready var slash_audio_player: AudioStreamPlayer2D = get_node(_slash_audio_player)

@export var animation: String

func enter(msg = {}):
	if !animation_player.is_playing():
		if msg.has("do_forward_slash"):
			print("forward slash")
			animation_player.play("slash")
			slash_audio_player.play()
		elif msg.has("do_down_slash"):
			print("down slash")
			animation_player.play("down_slash")
			slash_audio_player.play()

func physics_update(delta: float):
	
	var input_direction_x: float = (
		Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left")
	)
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	var move_direction = get_move_direction()
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.transition_to("Air", { do_jump = true })
	elif !player.is_on_floor():
		state_machine.transition_to("Air")
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.transition_to("Walk")
	elif is_equal_approx(move_direction.x, 0.0):
		state_machine.transition_to("Idle") 
