extends Area2D

@export var text_to_show = ""
enum MOODS { HAPPY, SAD, FREAKED_OUT }
@export var mood_to_show: MOODS = MOODS.HAPPY
@export var one_time = true
var shown = false


func _ready():
	connect("body_entered", show_text)
	connect("body_exited", hide_text)
	

func show_text(coll):
	if coll.is_in_group("player"):
		if one_time and shown:
			return
	shown = true
	TextDisplay.display_text(text_to_show, mood_to_show)

func hide_text(coll):
	if coll.is_in_group("player"):
		TextDisplay.hide_display()
	
