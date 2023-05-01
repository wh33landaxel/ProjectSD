extends Node

var level_ind = 0
var level_list = [
	"res://Levels/intro.tscn",
	"res://Levels/world.tscn",
	"res://Levels/level_3.tscn",
	"res://Levels/game_over.tscn"
]

var delete_on_load = []

func load_next_level():
	level_ind = (level_ind+1) % level_list.size()
	load_level(level_ind)

func restart_level():
	for d in delete_on_load:
		d.queue_free()
	delete_on_load = []
	get_tree().reload_current_scene()

func restart_game():
	for d in delete_on_load:
		d.queue_free()
	delete_on_load = []
	level_ind = 0
	load_level(0)

func load_level(ind):
	for d in delete_on_load:
		d.queue_free()
	delete_on_load = []
	get_tree().change_scene_to_file(level_list[ind])
