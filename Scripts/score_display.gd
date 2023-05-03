extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/Label

var time_elapsed = ""
var cur_time = 0

func _process(delta):

	cur_time += delta
	
	var minutes = int(cur_time / 60)
	var seconds = int(fmod(cur_time, 60))
	time_elapsed = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	label.text = "Time: " + time_elapsed

func restart_game():
	cur_time = 0
