extends Area2D

@onready var anim_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("alert_appeared")


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print(area)
	if area.is_in_group("slash"):
		anim_player.play("explosion")
		audio_player.play()


func _on_animation_finished(anim_name):
	if anim_name == "explosion":
		queue_free()
