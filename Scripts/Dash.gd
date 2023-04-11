extends Node2D

signal dash_ended

const DASH_DELAY = 0.4

@onready var duration_timer = $DurationTimer
@onready var ghost_timer = $GhostTimer

var ghost_scene = preload("res://Scenes/dash_ghost.tscn")
var can_dash = true
var sprite

func start_dash(sprite, duration):
	self.sprite = sprite
	
	duration_timer.wait_time = duration
	duration_timer.start()
	ghost_timer.start()
	
	instantiate_ghost()
	
func instantiate_ghost():
	var ghost: Sprite2D = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
	
	var current_frame_index = sprite.frame
	var frame = sprite.sprite_frames.get_frame_texture("walking", current_frame_index)
	ghost.texture = frame
	ghost.scale = Vector2(3,3)
	
	ghost.global_position = global_position
	ghost.flip_h = sprite.flip_h

func is_dashing():
	return !duration_timer.is_stopped()
	
func end_dash(): 
	ghost_timer.stop()
	can_dash = false
	await get_tree().create_timer(DASH_DELAY).timeout
	can_dash = true

func _on_duration_timer_timeout():
	end_dash()
	emit_signal("dash_ended")

func _on_ghost_timer_timeout():
	instantiate_ghost()
