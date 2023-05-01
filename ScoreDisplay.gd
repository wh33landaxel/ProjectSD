extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/Label
var cur_time = 0

func _process(delta):

	cur_time += delta
	
	var minutes = int(cur_time / 60)
	var seconds = int(fmod(cur_time, 60))
	label.text = "Time: " + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

func restart_game():
	cur_time = 0
