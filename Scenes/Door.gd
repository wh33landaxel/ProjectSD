extends Area2D

@export var go_to_next_level = true
var door_locked = false 

func _physics_process(delta):
	#super ineffcient but game jam
	if get_tree().get_nodes_in_group("alert_node").size() > 0:
		door_locked = true
	else:
		door_locked = false
