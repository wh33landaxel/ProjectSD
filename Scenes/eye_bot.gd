extends CharacterBody2D

var dir = Vector2()
var player
@export var offset = 50
const SPEED = 50
var health = 1

func _ready(): 
	player = Global.player
	dir = get_dir(player, 0)

func _physics_process(delta):
	dir = get_dir(player, 0)
	look_at(player.position)
	velocity = dir * SPEED
	move_and_slide()
	
func get_dir(target, diff):
	var ret = (target.position - position)
	var r = randf_range(-diff, diff)
	ret = Vector2(ret.x + r, ret.y + r).normalized()
	return ret


