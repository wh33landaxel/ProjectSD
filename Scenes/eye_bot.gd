extends CharacterBody2D

var dir = Vector2()
var player
@export var offset = 50
@export var on_path = false 
@onready var audio_player = $AudioStreamPlayer2D
@onready var anim_player = $AnimationPlayer
const SPEED = 50
var health = 1

func _ready(): 
	$ExplosionSprite2D.visible = false
	if not on_path:
		player = Global.player
		dir = get_dir(player, 0)
	
	

func _physics_process(delta):
	if not on_path: 
		dir = get_dir(player, 0)
		look_at(player.position)
		velocity = dir * SPEED
		move_and_slide()
	
func get_dir(target, diff):
	if not on_path:
		var ret = (target.position - position)
		var r = randf_range(-diff, diff)
		ret = Vector2(ret.x + r, ret.y + r).normalized()
		return ret


func _on_hit_area_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("slash"):
		anim_player.play("explosion")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explosion":
		queue_free()
	pass # Replace with function body.
