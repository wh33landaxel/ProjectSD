extends Node

var level_ind = 0
var level_list = [
	"res://Levels/intro.tscn",
	"res://Levels/world.tscn"
]

var delete_on_load = []

func load_next_level():
	level_ind = (level_ind+1) % level_list.size()
	load_level(level_ind)

func load_previous_level():
	level_ind = (level_ind-1) % level_list.size()
	load_level(level_ind)

func restart_level():
	for d in delete_on_load:
		d.queue_free()
	delete_on_load = []
	get_tree().reload_current_scene()

func load_level(ind):
	for d in delete_on_load:
		d.queue_free()
	delete_on_load = []
	get_tree().change_scene_to_file(level_list[ind])